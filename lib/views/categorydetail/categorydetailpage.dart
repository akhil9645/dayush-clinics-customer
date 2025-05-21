import 'dart:developer' as developer;

import 'package:dayush_clinic/controller/doctor_category_controller/doctor_category_controller.dart';
import 'package:dayush_clinic/controller/homecontroller/homecontroller.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Categorydetailpage extends StatefulWidget {
  const Categorydetailpage({super.key});

  @override
  State<Categorydetailpage> createState() => _CategorydetailpageState();
}

class _CategorydetailpageState extends State<Categorydetailpage> {
  final DoctorCategoryController doctorCategoryController =
      Get.put(DoctorCategoryController());
  final Homecontroller homecontroller = Get.find<Homecontroller>();

  String? selectedTab;

  @override
  void initState() {
    super.initState();
    homecontroller.getAllCategories().then((_) {
      if (homecontroller.categories.isNotEmpty) {
        final firstCategory = homecontroller.categories[0];
        selectedTab = firstCategory['name'];
        doctorCategoryController.selectedCategoryId.value =
            firstCategory['id'].toString();
        doctorCategoryController.getAvailableCategoryDoctors(
          categoryId: firstCategory['id'].toString(),
        );
        setState(() {}); // trigger UI update after setting selectedTab
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            selectedTab ?? '',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          forceMaterialTransparency: true,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10).r,
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20).r,
          child: Column(
            children: [
              Obx(
                () => homecontroller.categories.isEmpty
                    ? SizedBox()
                    : SizedBox(
                        height: 40.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: homecontroller.categories.length,
                          itemBuilder: (context, index) {
                            final category = homecontroller.categories[index];
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: _buildTab(
                                  category['name'], category['id'].toString()),
                            );
                          },
                        ),
                      ),
              ),
              Obx(
                () => doctorCategoryController.doctorsList.isNotEmpty
                    ? CategoryTab(
                        category: selectedTab ?? '',
                        imageUrl:
                            'assets/images/2195c1d242926995266846621b834170.png')
                    : Expanded(
                        child: Center(
                          child: Text(
                            'No doctors available for the selected category.',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTab(String title, String categoryId) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () async {
        setState(() {
          selectedTab = title;
        });
        doctorCategoryController.selectedCategoryId.value = categoryId;
        doctorCategoryController.getAvailableCategoryDoctors(
            categoryId: categoryId);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16).r,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Constants.buttoncolor : Colors.white,
        ),
        child: Center(
          child: Text(title,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  final String category;
  final String imageUrl;

  CategoryTab({
    super.key,
    required this.category,
    required this.imageUrl,
  });

  final DoctorCategoryController doctorCategoryController =
      Get.find<DoctorCategoryController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Recommended Doctors Section
            Constants().h10,
            Text(
              'Available Doctors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Obx(
              () => doctorCategoryController.doctorsList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: doctorCategoryController.doctorsList.length,
                      itemBuilder: (context, index) {
                        var doctor =
                            doctorCategoryController.doctorsList[index];
                        return DoctorCard(
                          experience: doctor['years_of_experience'] != null
                              ? doctor['years_of_experience'].toString()
                              : '0',
                          name: '${doctor['user']['username']}',
                          isAvaialble: doctor['is_available'],
                          consultationFee: doctor['consultation_fee'],
                          doctorDetail: doctor,
                        );
                      },
                    )
                  : Center(
                      child: Text('Doctor List is Empty'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  String? name;
  String? experience;
  bool? isAvaialble = true;
  dynamic doctorDetail;
  dynamic consultationFee;
  DoctorCard(
      {super.key,
      this.experience,
      this.name,
      this.consultationFee,
      this.isAvaialble,
      this.doctorDetail});

  final DoctorCategoryController doctorCategoryController =
      Get.find<DoctorCategoryController>();

  @override
  Widget build(BuildContext context) {
    String formattedFee = '';
    if (consultationFee != null) {
      try {
        double fee = double.parse(consultationFee.toString());
        formattedFee = fee.toStringAsFixed(0); // Remove decimal places
      } catch (e) {
        formattedFee = 'N/A'; // Fallback if parsing fails
        developer.log("Error parsing consultationFee: $e");
      }
    } else {
      formattedFee = 'N/A'; // Fallback for null
    }
    return Container(
      margin: EdgeInsets.only(bottom: 14).r,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12).r,
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(10).r,
        child: Row(
          children: [
            // Doctor Image
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/dcc39e9c2cc296b8f484a100aa6a49e9.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 10.w),

            // Doctor Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dr. $name",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹$formattedFee per Session',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Senior Consultant',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      // Experience
                      Icon(Icons.person,
                          color: Constants.buttoncolor, size: 24.sp),
                      Text(
                        '${experience ?? ''} years of Experience',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonWidgets().commonbutton(
                        buttonheight: 20,
                        fontsize: 8,
                        buttonwidth: 100,
                        title: Text(
                          'Book Appointment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ontap: () {
                          Get.toNamed(PageRoutes.patientInfo, arguments: {
                            'from': 'booknow',
                            'doctor': doctorDetail,
                            'selectedCategoryId': doctorCategoryController
                                .selectedCategoryId.value
                          });
                        },
                      ),
                      SizedBox(width: 5.w),
                      isAvaialble!
                          ? CommonWidgets().commonbutton(
                              buttonheight: 20,
                              fontsize: 8,
                              buttonwidth: 100,
                              title: Text(
                                'Consult Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ontap: () {
                                Get.toNamed(PageRoutes.patientInfo, arguments: {
                                  'from': 'consultnow',
                                  'doctor': doctorDetail,
                                  'selectedCategoryId': doctorCategoryController
                                      .selectedCategoryId.value
                                });
                              },
                            )
                          : SizedBox()
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
