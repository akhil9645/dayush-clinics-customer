import 'package:dayush_clinic/services/tokenstorage_Service.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:get/get.dart';

class Appcontroller extends GetxController {
  splashCheck() async {
    var token = await TokenStorageService().getToken();
    if (token != null && token.isNotEmpty) {
      Future.delayed(
          Duration(seconds: 3), () => Get.offAllNamed(PageRoutes.homepage));
    } else {
      Future.delayed(Duration(seconds: 3),
          () => Get.offAllNamed(PageRoutes.splashscreendialogue));
    }
  }
}
