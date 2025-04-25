import 'package:dayush_clinic/controller/profile_controller/profile_controller.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/0e4da77312f3cdaf1fb4ca76413499dc.png',
                  ),
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
            ),
            _buildMenuItem(
              icon: Icons.rate_review_rounded,
              title: 'Rate the app',
              color: Color(0xFF0B6B3D),
            ),
            _buildMenuItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              color: Colors.red,
              ontap: () => Get.offAllNamed(PageRoutes.login),
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
}
