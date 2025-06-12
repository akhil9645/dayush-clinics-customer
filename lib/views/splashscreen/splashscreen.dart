import 'package:dayush_clinic/controller/appcontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Splashscreen extends StatelessWidget {
  Splashscreen({super.key});

  final Appcontroller controller = Get.put(Appcontroller());

  @override
  Widget build(BuildContext context) {
    controller.splashCheck();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.width / 2,
              child: Image.asset(
                  'assets/images/59cc1b60234293ffa59fad969db4a07ea957962a.png'),
            ),
            SvgPicture.asset('assets/svg/splashscreen.svg'),
          ],
        ),
      ),
    );
  }
}
