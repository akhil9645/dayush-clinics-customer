import 'package:dayush_clinic/utils/common_widgets/common_widgets.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Categorydetailpage extends StatelessWidget {
  final List<String> categories = [
    'Ayurveda',
    'Homeopathy',
    'Siddha',
    'Unani',
    'Yoga',
    'Naturopathy'
  ];

  final Map<String, String> categoryImages = {
    'Ayurveda': 'assets/images/2195c1d242926995266846621b834170.png',
    'Homeopathy': 'assets/images/e6057101935f8cde0cff7dc90d717c86.png',
    'Siddha': 'assets/images/daf9d129356327697b638638e89f3732.png',
    'Unani': 'assets/images/70986d5328473b11ea4bcd65d808d918.png',
    'Yoga': 'assets/images/48afe0daf357a0cbc2c6bc3373d9dce8.png',
    'Naturopathy': 'assets/images/24037a8a7b5a3e49856f4e5df42917b6.png',
  };

  Categorydetailpage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
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
          bottom: TabBar(
            isScrollable: true,
            labelColor: Constants.buttoncolor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.lato().fontFamily),
            unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 11.sp,
                fontFamily: GoogleFonts.lato().fontFamily),
            indicatorColor: Constants.buttoncolor,
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories
              .map((category) => CategoryTab(
                    category: category,
                    imageUrl: categoryImages[category]!,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  final String category;
  final String imageUrl;

  const CategoryTab({
    super.key,
    required this.category,
    required this.imageUrl,
  });

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
                  'Recommended Doctors',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5, // Number of doctors
                  itemBuilder: (context, index) => DoctorCard(),
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
  const DoctorCard({super.key});

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
                    'Dr. John Doe',
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
                          '15 Years Exp.',
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
                    title: 'Book Appointment',
                    ontap: () {
                      Get.toNamed(PageRoutes.bookappointment);
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
