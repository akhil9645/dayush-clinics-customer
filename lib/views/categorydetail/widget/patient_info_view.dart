import 'package:dayush_clinic/controller/profile_controller/profile_controller.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/utils/validation_helper.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PatientInfoView extends StatefulWidget {
  final dynamic arguments;
  PatientInfoView({super.key}) : arguments = Get.arguments;

  @override
  State<PatientInfoView> createState() => _PatientInfoViewState();
}

class _PatientInfoViewState extends State<PatientInfoView> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController agecontroller = TextEditingController();
  final TextEditingController phonenumcontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  bool checkBoxValue = false;
  final ProfileController profileController = Get.put(ProfileController());
  Map<String, dynamic>? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.getUserProfile();
    data = data = widget.arguments as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar('Patient Info'),
      body: Form(
        key: formkey,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20).r,
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      'This patient information will be used for the prescription.',
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  )
                ],
              ),
              Constants().h10,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: checkBoxValue,
                      onChanged: (value) {
                        setState(() {
                          checkBoxValue = value ?? false;
                          if (checkBoxValue == true) {
                            namecontroller.text =
                                profileController.username.value;
                            phonenumcontroller.text =
                                profileController.phonenum.value;
                          } else {
                            namecontroller.clear();
                            phonenumcontroller.clear();
                          }
                        });
                      },
                      activeColor: Constants.buttoncolor,
                      checkColor: Colors.white,
                      side: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Text(
                    'Same as Profile Information',
                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  )
                ],
              ),
              Constants().h10,
              formHeadingTile('Patient Name'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: namecontroller,
                  validator: (p0) => ValidationHelper.nameValidation(p0 ?? ''),
                  keyboardtype: TextInputType.name,
                  hintText: 'Enter Patient Name'),
              SizedBox(height: 20.h),
              formHeadingTile('Patient Age'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: agecontroller,
                  validator: (p0) =>
                      ValidationHelper.normalValidation(p0 ?? ''),
                  keyboardtype: TextInputType.number,
                  hintText: 'Enter Patient Age'),
              SizedBox(height: 20.h),
              formHeadingTile('Patient Phone Number'),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: phonenumcontroller,
                  validator: (p0) =>
                      ValidationHelper.phoneNumberValidation(p0 ?? ''),
                  keyboardtype: TextInputType.phone,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ).r,
                    child: Text(
                      '+91',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                  ),
                  hintText: 'Enter Patient Phone Number'),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Disease Description',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Text(
                    ' (Optional)',
                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  )
                ],
              ),
              SizedBox(height: 5.h),
              CommonWidgets().commonTextfield(
                  textController: descriptioncontroller,
                  keyboardtype: TextInputType.text,
                  maxLines: 4,
                  hintText: 'Enter patient disease description'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
        child: CommonWidgets().commonbutton(
          title: Text(
            'Continue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          ontap: () {
            if (formkey.currentState!.validate()) {
              Get.toNamed(PageRoutes.bookappointment, arguments: {
                'from': data?['from'],
                'doctor': data?['doctor']
              });
            }
          },
        ),
      ),
    );
  }

  Row formHeadingTile(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        Text(
          '*',
          style: TextStyle(color: Color(0xFFED4713), fontSize: 14.sp),
        )
      ],
    );
  }
}
