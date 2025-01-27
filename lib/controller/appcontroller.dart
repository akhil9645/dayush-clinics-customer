import 'package:dayush_clinic/utils/routes.dart';
import 'package:get/get.dart';

class Appcontroller extends GetxController {
  splashCheck() {
    Future.delayed(Duration(seconds: 3),
        () => Get.offAllNamed(PageRoutes.splashscreendialogue));
  }
}
