import 'package:dayush_clinic/controller/profile_controller/profile_controller.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 100, bottom: 50).r,
            color: Color(0xFF0B6B3D),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
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
                    Container(
                      padding: EdgeInsets.all(4).r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit,
                          size: 16.sp, color: Color(0xFF0B6B3D)),
                    ),
                  ],
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
                    ),
                    // _buildMenuItem(
                    //   icon: Icons.calendar_today,
                    //   title: 'Scheduled Appointments',
                    //   color: Color(0xFF0B6B3D),
                    // ),
                    // _buildMenuItem(
                    //   icon: Icons.payment,
                    //   title: 'Payment Method',
                    //   color: Color(0xFF0B6B3D),
                    // ),
                    _buildMenuItem(
                      icon: Icons.question_answer,
                      title: 'FAQs',
                      color: Color(0xFF0B6B3D),
                    ),
                    _buildMenuItem(
                      icon: Icons.logout,
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
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
        onTap: () {},
      ),
    );
  }
}
