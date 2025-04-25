import 'package:dayush_clinic/views/authpages/createnewpassword.dart';
import 'package:dayush_clinic/views/authpages/forgetpassword.dart';
import 'package:dayush_clinic/views/authpages/login_page.dart';
import 'package:dayush_clinic/views/authpages/signup_page.dart';
import 'package:dayush_clinic/views/bookappointment/book_appointment.dart';
import 'package:dayush_clinic/views/bookappointment/payment_detail.dart';
import 'package:dayush_clinic/views/categorydetail/categorydetailpage.dart';
import 'package:dayush_clinic/views/categorydetail/widget/patient_info_view.dart';
import 'package:dayush_clinic/views/consultationHistory/consulationHistory_view.dart';
import 'package:dayush_clinic/views/homepage/homepage.dart';
import 'package:dayush_clinic/views/notification_view/notification_view.dart';
import 'package:dayush_clinic/views/profilepage/faq_view/faq_view.dart';
import 'package:dayush_clinic/views/profilepage/profile_screen.dart';
import 'package:dayush_clinic/views/scheduledappointmentspage/scheduledappointmentspage.dart';
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
  static const categorydetailpage = '/categorydetailpage';
  static const bookappointment = '/bookappointment';
  static const verifyOtp = '/verifyOtp';
  static const patientInfo = '/patientInfo';
  static const consultationHistory = '/consultationHistory';
  static const profile = '/profile';
  static const paymentDetail = '/paymentDetail';
  static const scheduledAppointment = '/scheduleAppointment';
  static const notificationview = '/notificationview';
  static const faqview = '/faqview';
}

List<GetPage<dynamic>> getpages = [
  GetPage(
    name: PageRoutes.splashscreendialogue,
    page: () => Splashscreendialogue(),
    transition: Transition.cupertino,
    transitionDuration: Duration(milliseconds: 200),
  ),
  GetPage(
    name: PageRoutes.homepage,
    page: () => Homepage(),
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
      name: PageRoutes.categorydetailpage,
      page: () => Categorydetailpage(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
  GetPage(
      name: PageRoutes.bookappointment,
      page: () => BookAppointment(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
  GetPage(
      name: PageRoutes.patientInfo,
      page: () => PatientInfoView(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
  GetPage(
      name: PageRoutes.profile,
      page: () => ProfileScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
  GetPage(
      name: PageRoutes.paymentDetail,
      page: () => PaymentDetail(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
  GetPage(
      name: PageRoutes.scheduledAppointment,
      page: () => Scheduledappointmentspage(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
  GetPage(
      name: PageRoutes.notificationview,
      page: () => NotificationView(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
  GetPage(
      name: PageRoutes.faqview,
      page: () => FaqView(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
  GetPage(
      name: PageRoutes.consultationHistory,
      page: () => ConsultationHistoryView(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 200)),
];
