import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:dayush_clinic/controller/appcontroller.dart';
import 'package:dayush_clinic/controller/authcontroller.dart';
import 'package:dayush_clinic/utils/routes.dart';
import 'package:dayush_clinic/views/splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _createNotificationChannel() async {
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'call_channel',
    'Call Notifications',
    description: 'Channel for video call notifications',
    importance: Importance.max,
    playSound: true,
    sound:
        const UriAndroidNotificationSound('content://settings/system/ringtone'),
    enableVibration: true,
    vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
  );
  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  developer.log('✅ Notification channel created');
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  developer.log('📩 [Background] Notification: ${message.notification?.title}');
  developer.log('📄 [Background] Data: ${message.data}');
  if (message.data['type'] == 'video_call') {
    // Prevent system tray from showing notification
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
    await _showCallNotification({
      'type': 'video_call',
      'consultation_id': message.data['consultation_id'] ?? '',
      'title': message.notification?.title ??
          message.data['title'] ??
          'Incoming Video Call',
      'body': message.notification?.body ??
          message.data['body'] ??
          'Consultation ID: ${message.data['consultation_id']}',
    });
  }
}

Future<void> _showCallNotification(Map<String, dynamic> data) async {
  try {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'call_channel',
      'Call Notifications',
      channelDescription: 'Channel for video call notifications',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      ticker: 'Incoming Call',
      channelShowBadge: false,
      autoCancel: false,
      timeoutAfter: 60000,
      playSound: true,
      sound: const UriAndroidNotificationSound(
          'content://settings/system/ringtone'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      category: AndroidNotificationCategory.call,
      icon: '@drawable/ic_launcher_foreground',
      ongoing: true,
      actions: [
        AndroidNotificationAction(
          'accept',
          'Accept',
          showsUserInterface: true,
        ),
      ],
    );
    // Fallback notification without full-screen intent
    AndroidNotificationDetails fallbackDetails = AndroidNotificationDetails(
      'call_channel',
      'Call Notifications',
      channelDescription: 'Channel for video call notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Incoming Call',
      channelShowBadge: false,
      autoCancel: false,
      timeoutAfter: 60000,
      playSound: true,
      sound: const UriAndroidNotificationSound(
          'content://settings/system/ringtone'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      category: AndroidNotificationCategory.call,
      icon: '@drawable/ic_launcher_foreground',
      ongoing: true,
      actions: [
        AndroidNotificationAction(
          'accept',
          'Accept',
          showsUserInterface: true,
        ),
      ],
    );
    NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    NotificationDetails fallbackPlatformDetails =
        NotificationDetails(android: fallbackDetails);

    // Try full-screen intent first
    await localNotificationsPlugin.show(
      0,
      data['title'] ?? 'Incoming Video Call',
      data['body'] ?? 'Consultation ID: ${data['consultation_id']}',
      platformDetails,
      payload: jsonEncode(data),
    );
    developer.log('✅ Call notification shown with full-screen intent');

    // Fallback if full-screen intent fails
    if (await Permission.systemAlertWindow.isDenied) {
      await localNotificationsPlugin.show(
        0,
        data['title'] ?? 'Incoming Video Call',
        data['body'] ?? 'Consultation ID: ${data['consultation_id']}',
        fallbackPlatformDetails,
        payload: jsonEncode(data),
      );
      developer.log('✅ Fallback notification shown without full-screen intent');
    }
  } catch (e, stackTrace) {
    developer.log('Error showing call notification: $e',
        stackTrace: stackTrace, level: 1000);
  }
}

void _navigateToVideoCall(Map<String, dynamic> data) {
  try {
    if (data['consultation_id'] != null) {
      Get.offAllNamed(
        PageRoutes.videocallmainpage,
        arguments: {
          'consultationDetails': {'id': data['consultation_id']},
        },
      );
    } else {
      developer.log('Invalid consultation_id in notification payload',
          level: 1000);
      Get.snackbar('Error', 'Invalid consultation ID');
    }
  } catch (e, stackTrace) {
    developer.log('Error navigating to video call: $e',
        stackTrace: stackTrace, level: 1000);
    Get.snackbar('Error', 'Failed to navigate to video call');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  try {
    await Firebase.initializeApp();
    developer.log("✅ Firebase Initialized Successfully");

    await _createNotificationChannel();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        try {
          if (response.payload != null) {
            final payload = jsonDecode(response.payload!);
            if (payload['type'] == 'video_call' &&
                response.actionId == 'accept') {
              _navigateToVideoCall(payload);
            }
          }
        } catch (e, stackTrace) {
          developer.log('Error handling notification tap: $e',
              stackTrace: stackTrace, level: 1000);
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    String? fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      developer.log('🔑 FCM Token: $fcmToken');
    } catch (e) {
      developer.log("⚠ Error getting FCM token: $e", level: 1000);
    }

    runApp(MyApp(token: fcmToken ?? ''));
  } catch (e, stackTrace) {
    developer.log("🚨 Firebase Initialization Failed: $e",
        stackTrace: stackTrace, level: 1000);
    runApp(MyApp(token: ''));
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
    super.initState();
    _requestNotificationPermissions();
    _listenToMessages();
    if (widget.token != null && widget.token!.isNotEmpty) {
      authcontroller.fcmtoken = widget.token;
    } else {
      developer.log("Fcm token is null or empty", level: 1000);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      authcontroller.fcmtoken = fcmToken;
      developer.log('🔑 FCM Token Refreshed: $fcmToken');
    }).onError((e, stackTrace) {
      developer.log('Error on token refresh: $e',
          stackTrace: stackTrace, level: 1000);
    });
  }

  void _requestNotificationPermissions() async {
    try {
      if (await Permission.notification.isDenied) {
        PermissionStatus status = await Permission.notification.request();
        developer.log('🔍 Android Notification Permission Status: $status');
        if (status.isGranted) {
          developer.log('✅ Android User granted notification permission');
        } else {
          developer.log('❌ Android User denied notification permission');
          Get.snackbar('Permission Required',
              'Please enable notifications in settings for call functionality',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        developer.log('✅ Android Notification permission already granted');
      }
    } catch (e, stackTrace) {
      developer.log("⚠ Error requesting permissions: $e",
          stackTrace: stackTrace, level: 1000);
    }
  }

  void _listenToMessages() async {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        developer.log(
            "📲 Foreground Notification Received: ${message.notification?.title}");
        developer.log("📄 Data: ${message.data}");
        if (message.data['type'] == 'video_call') {
          await _showCallNotification({
            'type': 'video_call',
            'consultation_id': message.data['consultation_id'] ?? '',
            'title': message.notification?.title ?? 'Incoming Video Call',
            'body': message.notification?.body ??
                'Consultation ID: ${message.data['consultation_id']}',
          });
        }
      });

      localNotificationsPlugin
          .getNotificationAppLaunchDetails()
          .then((details) {
        if (details != null && details.notificationResponse?.payload != null) {
          try {
            final payload = jsonDecode(details.notificationResponse!.payload!);
            if (payload['type'] == 'video_call') {
              _navigateToVideoCall(payload);
            }
          } catch (e, stackTrace) {
            developer.log('Error handling launch notification: $e',
                stackTrace: stackTrace, level: 1000);
          }
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        developer
            .log("🔄 Notification Clicked: ${message.notification?.title}");
        if (message.data['type'] == 'video_call') {
          _navigateToVideoCall(message.data);
        }
      });

      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null && message.data['type'] == 'video_call') {
          developer.log(
              "🚀 App opened from notification: ${message.notification?.title}");
          _navigateToVideoCall(message.data);
        }
      });
    } catch (e, stackTrace) {
      developer.log('Error setting up message listeners: $e',
          stackTrace: stackTrace, level: 1000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: BindingsBuilder(() {
            Get.put(Appcontroller());
          }),
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.green,
            fontFamily: GoogleFonts.dmSans().fontFamily,
          ),
          home: Splashscreen(),
          getPages: getpages,
        );
      },
    );
  }
}
