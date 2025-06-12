import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/controller/homecontroller/homecontroller.dart';
import 'package:dayush_clinic/controller/profile_controller/profile_controller.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Homecontroller homecontroller = Get.put(Homecontroller());
  final Authcontroller authcontroller = Get.find<Authcontroller>();
  final ProfileController profileController = Get.put(ProfileController());

  final Map<String, String> categoryImageMap = {
    'Ayurveda': 'assets/images/Ayurveda.560eaf93.PNG',
    'Homeopathy': 'assets/images/be562f64-9904-49d6-9e09-a011ccacb718.jpg',
    'Naturopathy': 'assets/images/naturopathy.7f0d5bb3.PNG',
    'Sidha': 'assets/images/siddha medicine.972ef1a6.PNG',
    'Unani': 'assets/images/homeopathy logo.b7b3f219.PNG',
    'Yoga and Meditation': 'assets/images/Yoga Therapy.991a3c30 (2).png',
  };

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homecontroller.getAllCategories();
    profileController.getUserProfile();
    authcontroller.updateFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldkey,
      drawer: Constants().appDrawer(context, profileController),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        forceMaterialTransparency: true,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(PageRoutes.notificationview);
            },
            icon: Icon(Icons.notifications, size: 24.w),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.r),
            child: GestureDetector(
              onTap: () => Get.toNamed(PageRoutes.profile),
              child: CircleAvatar(
                radius: 24.r,
                backgroundColor: Colors.transparent,
                child: SvgPicture.asset(
                  'assets/svg/profile_icon.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: EdgeInsets.only(left: 15.r),
          child: GestureDetector(
            onTap: () {
              _scafoldkey.currentState?.openDrawer();
            },
            child: Icon(Icons.menu_rounded, color: Colors.black, size: 24.w),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(bottom: 15).r,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            height: 40.h,
            child: SvgPicture.asset(
              'assets/svg/dayushclinics.svg',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20).r,
        child: ListView(
          children: [
            Obx(
              () => Text(
                'Hi ${profileController.username}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              'What are you looking for?',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
            Constants().h10,
            Constants().h10,
            Text(
              'Select Category',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Constants().h10,
            Obx(
              () => GridView.builder(
                shrinkWrap: true,
                itemCount: homecontroller.categories.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  var data = homecontroller.categories[index];
                  String categoryName =
                      homecontroller.categories[index]['name'];
                  String imagePath = categoryImageMap[categoryName] ??
                      'assets/images/Ayurveda.560eaf93.PNG';

                  return Container(
                    decoration: BoxDecoration(
                      color: Constants.buttoncolor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  backgroundColor: Colors.white,
                                  contentPadding: EdgeInsets.all(20.r),
                                  content: Column(
                                    mainAxisSize:
                                        MainAxisSize.min, // To wrap content
                                    children: [
                                      // Category Image
                                      CircleAvatar(
                                        radius: 30.r,
                                        backgroundImage: AssetImage(
                                          imagePath,
                                        ),
                                      ),
                                      SizedBox(height: 15.h),
                                      // Category Name
                                      Text(
                                        categoryName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10.h),
                                      // Category Description
                                      Text(
                                        data['description'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Close the dialog
                                      },
                                      child: Text(
                                        'Close',
                                        style: TextStyle(
                                          color: Constants.buttoncolor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    CommonWidgets().commonbutton(
                                      buttonheight: 25,
                                      fontsize: 14,
                                      buttonwidth: 120,
                                      title: Text(
                                        'Consult Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ontap: () {
                                        Get.toNamed(
                                            PageRoutes.categorydetailpage,
                                            arguments: {
                                              'categoryName': data['name'],
                                              'categoryId':
                                                  data['id'].toString(),
                                            });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 24.r,
                            backgroundImage: AssetImage(imagePath),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          data['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () => Get.toNamed(
                                PageRoutes.categorydetailpage,
                                arguments: {
                                  'categoryName': data['name'],
                                  'categoryId': data['id'].toString(),
                                }),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12).r,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    'Consult Now',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            WellnessSection(),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Constants.buttoncolor,
                borderRadius: BorderRadius.circular(12).r,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dayush Clinics',
                    style: TextStyle(
                      color: Colors.white, // Dark teal color
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  // Subheading
                  Text(
                    'One Stop Solution For Digital Consultations In Alternate Medicine Treatments.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CommonWidgets().commonbutton(
                    buttonColor: Colors.white,
                    title: Text(
                      'Know More About Us',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ontap: () {
                      Get.toNamed(PageRoutes.aboutus);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h)
          ],
        ),
      ),
    );
  }
}

class WellnessSection extends StatelessWidget {
  const WellnessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6F5EB),
        borderRadius: BorderRadius.circular(12).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 30.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Text(
            'Your Wellness, Anytime & Anywhere',
            style: TextStyle(
              color: const Color(0xFF1A3C34), // Dark teal color
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          // Subheading
          Text(
            'Get connected with certified practitioners and personalized care—from the comfort of your home.',
            style: TextStyle(
              color: const Color(0xFF1A3C34).withOpacity(0.8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10.h),
          // List of items
          const WellnessItem(
            icon: Icons.computer, // Replace with your icon asset if needed
            title: 'Digital Availability',
            description:
                'Doctors available 24×7 for consultations and emergencies',
          ),
          SizedBox(height: 10.h),
          const WellnessItem(
            icon: Icons.access_time,
            title: 'Anytime Accessibility',
            description: 'Connect via video calls seamlessly',
          ),
          SizedBox(height: 10.h),
          const WellnessItem(
            icon: Icons.favorite,
            title: 'Your-care Plans',
            description:
                'Customized health plans combining modern and traditional care',
          ),
          SizedBox(height: 10.h),
          const WellnessItem(
            icon: Icons.support,
            title: 'Ultra Comfort',
            description:
                'Receive expert care and guidance without stepping out through virtual consultations',
          ),
          SizedBox(height: 10.h),
          const WellnessItem(
            icon: Icons.support_agent,
            title: 'Sustained Support',
            description:
                'Continuous support and anytime/anywhere prescription download facility',
          ),
          SizedBox(height: 10.h),
          const WellnessItem(
            icon: Icons.self_improvement,
            title: 'Holistic Healing',
            description: 'Wellness through emotinal & physical improvement.',
          ),
        ],
      ),
    );
  }
}

// Widget for each list item
class WellnessItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const WellnessItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final capitalizedTitle = _capitalizeFirstLetter(title);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Icon(
          icon,
          size: 24.w,
          color: Constants.buttoncolor, // Green color for icons
        ),
        SizedBox(width: 12.w),
        // Title and Description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with first letter larger
              RichText(
                text: TextSpan(
                  children: [
                    // First letter with larger font size
                    TextSpan(
                      text: capitalizedTitle[0],
                      style: TextStyle(
                        color: const Color(0xFF1A3C34),
                        fontSize:
                            20.sp, // Larger font size for the first letter
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                      ),
                    ),
                    // Rest of the title
                    TextSpan(
                      text: capitalizedTitle.substring(1),
                      style: TextStyle(
                        color: const Color(0xFF1A3C34),
                        fontSize: 16.sp, // Original font size for the rest
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              // Description
              Text(
                description,
                style: TextStyle(
                  color: const Color(0xFF1A3C34).withOpacity(0.7),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
