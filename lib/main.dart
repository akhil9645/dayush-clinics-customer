import 'dart:developer';
import 'dart:io';

import 'package:dayush_clinic/controller/appcontroller.dart';
import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  log('📩 [Background] Notification: ${message.notification?.title}');
  log('📄 [Background] Data: ${message.data}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  try {
    await Firebase.initializeApp();
    log("✅ Firebase Initialized Successfully");

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    String? fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      log('🔑 FCM Token: $fcmToken');
    } catch (e) {
      log("⚠ Error getting FCM token: $e");
    }

    runApp(MyApp(token: fcmToken ?? 'null'));
  } catch (e) {
    log("🚨 Firebase Initialization Failed: $e");
  }
}

class MyApp extends StatefulWidget {
  final String? token;
  const MyApp({super.key, required this.token});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Authcontroller authcontroller = Get.put(Authcontroller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestNotificationPermissions();
    listentoMessages();
    if (widget.token != null && widget.token!.isNotEmpty) {
      authcontroller.fcmtoken = widget.token;
    } else {
      log("Fcm token is null or empty");
    }
  }

  void listentoMessages() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("📲 Foreground Notification Received: ${message.notification?.title}");
      log("📄 Data: ${message.data}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("🔄 Notification Clicked: ${message.notification?.title}");
      // Get.toNamed(AppRoutes.notificationScreen);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log("🚀 App opened from notification: ${message.notification?.title}");
        // Get.toNamed(AppRoutes.notificationScreen);
      }
    });
  }

  void _requestNotificationPermissions() async {
    try {
      if (Platform.isIOS) {
        NotificationSettings settings =
            await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        log('🔍 iOS Notification Permission Status: ${settings.authorizationStatus}');
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          log('✅ iOS User granted notification permission');
        } else {
          log('❌ iOS User denied notification permission');
        }
      } else if (Platform.isAndroid) {
        if (await Permission.notification.isDenied) {
          PermissionStatus status = await Permission.notification.request();
          log('🔍 Android Notification Permission Status: $status');
          if (status.isGranted) {
            log('✅ Android User granted notification permission');
          } else {
            log('❌ Android User denied notification permission');
          }
        } else {
          log('✅ Android Notification permission already granted');
        }
      }
    } catch (e) {
      log("⚠ Error requesting notification permissions: $e");
    }
  }

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
              fontFamily: GoogleFonts.dmSans().fontFamily),
          home: Splashscreen(),
          getPages: getpages,
        );
      },
    );
  }
}
