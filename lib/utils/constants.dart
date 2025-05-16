import 'package:dayush_clinic/controller/profile_controller/profile_controller.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/profilepage/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Constants {
  static const buttoncolor = Color(0xFF0D6D2E);
  SizedBox h10 = SizedBox(height: 10.h);
  Drawer appDrawer(BuildContext context, ProfileController profilecontroller) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100.h,
            ),
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.w),
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  'assets/svg/profile_icon.svg', // Updated to SVG
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Obx(
              () => Text(
                'Hi ${profilecontroller.username.value}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Constants().h10,
            _buildMenuItem(
              icon: Icons.calendar_today,
              title: 'Consultation History',
              color: Color(0xFF0B6B3D),
              ontap: () {
                Get.toNamed(PageRoutes.consultationHistory);
              },
            ),
            _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'Help Centers',
                color: Color(0xFF0B6B3D),
                ontap: () async {
                  bottomSheetSupport(context, profilecontroller);
                }),
            _buildMenuItem(
              icon: Icons.rate_review_rounded,
              title: 'Rate the app',
              color: Color(0xFF0B6B3D),
            ),
            _buildMenuItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              color: Colors.red,
              ontap: () {
                showSuccessDialog(context, 'assets/svg/logout_icon.svg',
                    buttonTitle: 'Logout', ontap: () {
                  profilecontroller.userLogout(context);
                }, title: 'Are you sure to log out of your account?');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required Color color,
      Function()? ontap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: ontap,
    );
  }

  Future<dynamic> bottomSheetSupport(
      BuildContext context, ProfileController profilecontroller) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2.2,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 20).r,
                    child: Text(
                      "Want to talk to us?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.sp),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 20).r,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: 90.w,
                height: 90.h,
                child:
                    Image.asset("assets/images/icons8-online-support-96.png"),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Reach out to Dayush Clinic's team!",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "We are glad to help you any time",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  supportButtons(
                      () => sendEmail(profilecontroller.username.value,
                          'dayushclinics@gmail.com'),
                      "assets/svg/gmail.svg",
                      "Email Us"),
                  supportButtons(
                      () => sendEmail(profilecontroller.username.value,
                          'support@dayushclinics.com'),
                      "assets/svg/gmail.svg",
                      "Email Us"),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  GestureDetector supportButtons(
      void Function()? onTap, String imagePath, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        height: 35.h,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade600)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 25, height: 25, child: SvgPicture.asset(imagePath)),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }

  sendEmail(String? username, String email) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Dayush Clinic Support',
        'body':
            'Hi, I am ${username?.toUpperCase()}.\n\n I have a query about Dayush Clinic app. Need support!\n\nUser: ${username!.toUpperCase()}'
      }),
    );

    launchUrl(emailLaunchUri);
  }
}
