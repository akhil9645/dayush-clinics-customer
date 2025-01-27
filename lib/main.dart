import 'package:dayush_clinic/controller/appcontroller.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: BindingsBuilder(
            () {
              Get.put(Appcontroller());
            },
          ),
          theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.green,
              fontFamily: GoogleFonts.lato().fontFamily),
          home: Splashscreen(),
          getPages: getpages,
        );
      },
    );
  }
}
