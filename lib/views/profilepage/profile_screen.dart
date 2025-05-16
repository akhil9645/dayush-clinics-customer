import 'package:dayush_clinic/controller/profile_controller/profile_controller.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.buttoncolor,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.r),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 75, bottom: 50).r,
            color: Color(0xFF0B6B3D),
            child: Column(
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.w),
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/c0301b58c7a6336d8509dfdd7a892c56.png'),
                    ),
                  ),
                ),
                Constants().h10,
                Obx(
                  () => Text(
                    profileController.username.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMenuItem(
                      icon: Icons.history,
                      title: 'Consultation History',
                      color: Color(0xFF0B6B3D),
                      ontap: () => Get.toNamed(PageRoutes.consultationHistory),
                    ),
                    _buildMenuItem(
                      icon: Icons.calendar_today,
                      title: 'Scheduled Appointments',
                      ontap: () => Get.toNamed(PageRoutes.scheduledAppointment),
                      color: Color(0xFF0B6B3D),
                    ),
                    _buildMenuItem(
                      icon: Icons.info_outline_rounded,
                      title: 'About Us',
                      ontap: () {
                        Get.toNamed(PageRoutes.aboutus);
                      },
                      color: Color(0xFF0B6B3D),
                    ),
                    _buildMenuItem(
                      icon: Icons.question_answer,
                      title: 'FAQs',
                      ontap: () {
                        Get.toNamed(PageRoutes.faqview);
                      },
                      color: Color(0xFF0B6B3D),
                    ),
                    _buildMenuItem(
                      icon: Icons.logout,
                      ontap: () {
                        showSuccessDialog(context, 'assets/svg/logout_icon.svg',
                            buttonTitle: 'Logout', ontap: () {
                          profileController.userLogout(context);
                        }, title: 'Are you sure to log out of your account?');
                      },
                      title: 'Logout',
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required Color color,
      required Function()? ontap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16).r,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12).r,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8).r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: ontap,
      ),
    );
  }
}

void showSuccessDialog(BuildContext context, String? iconPath,
    {String? title, String? buttonTitle, Function()? ontap}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12).r,
        ),
        content: Container(
          width: 284.w,
          height: 280.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12).r,
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              SvgPicture.asset(
                iconPath ?? "",
                width: 61.w,
                height: 61.h,
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title ?? '',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: CommonWidgets().commonbutton(
                  title: Text(
                    buttonTitle ?? '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  ontap: ontap,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: CommonWidgets().commonbutton(
                  buttonColor: Colors.grey.shade100,
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Constants.buttoncolor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  ontap: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
