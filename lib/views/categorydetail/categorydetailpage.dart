import 'package:dayush_clinic/controller/doctor_category_controller/doctor_category_controller.dart';
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
  late String categoryId;

  @override
  void initState() {
    super.initState();
    categoryId = Get.arguments['categoryId'].toString();
    doctorCategoryController.getAvailableCategoryDoctors(
        categoryId: categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Category Detail',
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
        body: CategoryTab(
            category: 'Ayurveda',
            imageUrl: 'assets/images/2195c1d242926995266846621b834170.png'));
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
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20).r,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              doctorCategoryController.doctorsList.length,
                          itemBuilder: (context, index) {
                            var doctor =
                                doctorCategoryController.doctorsList[index];
                            return DoctorCard(
                              experience: doctor['user']
                                      ['years_of_experience'] ??
                                  'N/A',
                              name: '${doctor['user']['username']}s',
                            );
                          },
                        )
                      : Center(
                          child: Text('Doctor List is Empty'),
                        ),
                ),
              ],
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

  DoctorCard({super.key, this.experience, this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Doctor Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/dcc39e9c2cc296b8f484a100aa6a49e9.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(width: 16),

            // Doctor Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Senior Consultant',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // Experience
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          experience ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  CommonWidgets().commonbutton(
                    buttonheight: 20,
                    fontsize: 8,
                    buttonwidth: 50,
                    title: Text(
                      'Consult Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ontap: () {
                      Get.toNamed(PageRoutes.patientInfo);
                    },
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
