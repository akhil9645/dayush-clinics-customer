import 'package:dayush_clinic/controller/homecontroller/homecontroller.dart';
import 'package:dayush_clinic/controller/profile_controller/profile_controller.dart';
import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Homecontroller homecontroller = Get.put(Homecontroller());
  final ProfileController profileController = Get.put(ProfileController());

  final TextEditingController searchcontroller = TextEditingController();

  final categoryimages = [
    'assets/images/d481906f8802fa20cea665be3998d197.png',
    'assets/images/c91b19a4f82085371267ec307b802460.png',
    'assets/images/c0301b58c7a6336d8509dfdd7a892c56.png',
    'assets/images/c8ef29ed20d409bb0e8e07b71466980a.png',
    'assets/images/ee6457e6cf7aa69688584f84b263b5cd.png',
    'assets/images/5b2ab08d978be22d8702879b6a7d1efd.png'
  ];

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homecontroller.getAllCategories();
    profileController.getUserProfile();
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
          Padding(
            padding: EdgeInsets.only(right: 15.r),
            child: Badge(
              backgroundColor: Colors.red,
              label: Text('1'),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications,
                    size: 20.w,
                  )),
            ),
          )
        ],
        leading: Padding(
          padding: EdgeInsets.only(left: 15.r),
          child: GestureDetector(
            onTap: () {
              _scafoldkey.currentState?.openDrawer();
            },
            child: Icon(
              Icons.menu_rounded,
              color: Colors.black,
              size: 24.w,
            ),
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
                    fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              'What are you looking for?',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
            Constants().h10,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                controller: searchcontroller,
                cursorColor: Constants.buttoncolor,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(12).w,
                  hintText: 'Doctors, Appointments, Ayurveda, etc..',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Constants().h10,
            Text(
              'Select Category',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600),
            ),
            Constants().h10,
            Obx(
              () => GridView.builder(
                shrinkWrap: true,
                itemCount: homecontroller.categories.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  var data = homecontroller.categories[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed(PageRoutes.categorydetailpage,
                        arguments: {'categoryId': data['id']}),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Constants.buttoncolor,
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 5.r),
                          CircleAvatar(
                            radius: 24.r,
                            backgroundImage: AssetImage(categoryimages[index]),
                          ),
                          SizedBox(height: 5.r),
                          Text(
                            data['name'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Constants().h10,
            Constants().h10,
            _buildMenuItem(
              icon: Icons.history,
              title: 'Consultation History',
              color: Color(0xFF0B6B3D),
              ontap: () => Get.toNamed(PageRoutes.consultationHistory),
            ),
            // Text(
            //   'Activities',
            //   style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 18.sp,
            //       fontWeight: FontWeight.w600),
            // ),
            // Constants().h10,
            // ListView.builder(
            //   itemCount: 2,
            //   shrinkWrap: true,
            //   physics: BouncingScrollPhysics(),
            //   padding: EdgeInsets.zero,
            //   itemBuilder: (context, index) {
            //     var images = [
            //       'assets/images/0e4da77312f3cdaf1fb4ca76413499dc.png',
            //       'assets/images/2195c1d242926995266846621b834170.png'
            //     ];
            //     var titles = ['Daily Live Yoga Classes', '1-Day workshop'];
            //     var subtitle = ['Morning-6.30-7.30 Am', 'Benefits of Ayurveda'];
            //     var text = ['Evening-6.30-7.30 Pm', 'Morning-6.30-7.30 Am'];
            //     return Padding(
            //       padding: const EdgeInsets.only(bottom: 10).r,
            //       child: Container(
            //         decoration: BoxDecoration(
            //           border: Border.all(
            //             color: Colors.grey,
            //           ),
            //           borderRadius: BorderRadius.circular(10.r),
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.all(10.0).r,
            //           child: Row(
            //             children: [
            //               SizedBox(
            //                 width: 100.w,
            //                 height: 100.h,
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(10.r),
            //                   child: Image.asset(
            //                     images[index],
            //                     fit: BoxFit.fitHeight,
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(width: 10.w),
            //               Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     titles[index],
            //                     style: TextStyle(
            //                         color: Colors.black,
            //                         fontSize: 16.sp,
            //                         fontWeight: FontWeight.w600),
            //                   ),
            //                   Text(
            //                     subtitle[index],
            //                     style: TextStyle(
            //                         color: Colors.grey, fontSize: 12.sp),
            //                   ),
            //                   Text(
            //                     text[index],
            //                     style: TextStyle(
            //                         color: Colors.grey, fontSize: 12.sp),
            //                   ),
            //                 ],
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // )
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
