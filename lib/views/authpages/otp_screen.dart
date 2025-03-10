import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/dio_handler.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VerifyOtp extends StatefulWidget {
  final String userEmail;
  const VerifyOtp({super.key, required this.userEmail});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final Authcontroller authcontroller = Get.put(Authcontroller());
  final int _otpLength = 4;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  Timer? _timer;
  int _timeLeft = 179; // 2:59 in seconds

  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes
    for (int i = 0; i < _otpLength; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String get timerText {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar(),
      body: Padding(
        padding: EdgeInsets.only(left: 25, right: 25, top: 50).r,
        child: ListView(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'OTP Sent to your registered email ID',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_otpLength, (index) {
                return SizedBox(
                  width: 45.w,
                  height: 45.h,
                  child: KeyboardListener(
                    focusNode: FocusNode(), // Needed for capturing key events
                    onKeyEvent: (event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.backspace &&
                          _controllers[index].text.isEmpty &&
                          index > 0) {
                        _focusNodes[index - 1].requestFocus();
                        _controllers[index - 1].clear();
                      }
                    },
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 2,
                        ).r,
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4).r,
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4).r,
                          borderSide:
                              const BorderSide(color: Colors.orange, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < _otpLength - 1) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 30.h),
            SizedBox(height: 30.h),
            Obx(() => CommonWidgets().commonbutton(
                  title: authcontroller.isLoading.value
                      ? LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 10,
                        )
                      : Text(
                          'Verify',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ontap: () async {
                    // Concatenate OTP from the controllers
                    String otp = _controllers
                        .map((controller) => controller.text)
                        .join('');

                    // Check if OTP is valid (if it's not empty)
                    if (otp.isEmpty || otp.length != _otpLength) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CommonWidgets()
                            .snackBarinfo("Please enter a valid OTP"),
                      );
                      return;
                    } else {
                      await authcontroller.validateOtp(
                          widget.userEmail, otp, context);
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
