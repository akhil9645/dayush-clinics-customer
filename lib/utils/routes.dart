import 'package:dayush_clinic/views/authpages/createnewpassword.dart';
import 'package:dayush_clinic/views/authpages/forgetpassword.dart';
import 'package:dayush_clinic/views/authpages/login_page.dart';
import 'package:dayush_clinic/views/authpages/signup_page.dart';
import 'package:dayush_clinic/views/bookappointment/book_appointment.dart';
import 'package:dayush_clinic/views/categorydetail/categorydetailpage.dart';
import 'package:dayush_clinic/views/mainpage.dart';
import 'package:dayush_clinic/views/splashscreen/splashscreendialogue.dart';
import 'package:dayush_clinic/views/videocall/videocallmain.dart';
import 'package:get/get.dart';

class PageRoutes {
  static const splashscreendialogue = '/splashscreendialogue';
  static const login = '/login';
  static const signup = '/signup';
  static const forgetpassword = '/forgetpassword';

  static const createnewpassword = '/createnewpassword';
  static const termsandconditions = '/termsandconditions';
  static const homepage = '/homepage';
  static const videocallmainpage = '/videocallmainpage';
  static const mainpage = '/mainpage';
  static const categorydetailpage = '/categorydetailpage';
  static const bookappointment = '/bookappointment';
  static const verifyOtp = '/verifyOtp';
}

List<GetPage<dynamic>> getpages = [
  GetPage(
    name: PageRoutes.splashscreendialogue,
    page: () => Splashscreendialogue(),
    transition: Transition.cupertino,
    transitionDuration: Duration(milliseconds: 200),
  ),
  GetPage(
    name: PageRoutes.login,
    page: () => LoginPage(),
    transition: Transition.cupertino,
    transitionDuration: Duration(milliseconds: 200),
  ),
  GetPage(
    name: PageRoutes.signup,
    page: () => SignupPage(),
    transition: Transition.cupertino,
    transitionDuration: Duration(milliseconds: 200),
  ),
  GetPage(
    name: PageRoutes.forgetpassword,
    page: () => Forgetpassword(),
    transition: Transition.cupertino,
    transitionDuration: Duration(milliseconds: 200),
  ),
  GetPage(
    name: PageRoutes.createnewpassword,
    page: () => Createnewpassword(),
    transition: Transition.cupertino,
    transitionDuration: Duration(milliseconds: 200),
  ),
  GetPage(
    name: PageRoutes.videocallmainpage,
    page: () => Videocallmain(),
    transition: Transition.cupertino,
    transitionDuration: Duration(milliseconds: 200),
  ),
  GetPage(
      name: PageRoutes.mainpage,
      page: () => Mainpage(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
  GetPage(
      name: PageRoutes.categorydetailpage,
      page: () => Categorydetailpage(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
  GetPage(
      name: PageRoutes.bookappointment,
      page: () => BookAppointment(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
];
