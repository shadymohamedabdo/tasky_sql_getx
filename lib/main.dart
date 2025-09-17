import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskt/to_do_app/Database/task_view.dart';
import 'package:taskt/to_do_app/constants/constants_url.dart';
import 'package:taskt/to_do_app/get/edit_controller.dart';
import 'package:taskt/to_do_app/get/profile_controller.dart';
import 'package:taskt/to_do_app/get/task_view_controller.dart';
import 'package:taskt/to_do_app/get/theme_controller.dart';
import 'package:taskt/to_do_app/inital/splash.dart';

void main() async {
  Get.put(ProfileController());
  Get.put(EditController());
  Get.put(TaskViewController());
  Get.put(ThemeController());
  WidgetsFlutterBinding.ensureInitialized();

  // طلب إذن الإشعارات
  AwesomeNotifications().initialize(null,
    [
      NotificationChannel(
        icon: kNotificationIcon,
        channelKey: kChannelKey,
        channelName: 'إشعارات المهام',
        channelDescription: 'إشعار عند وصول موعد المهمة',
        defaultColor: Colors.blue,
        importance: NotificationImportance.Max,
        ledColor: Colors.white,
        playSound: true,            // 🔹 يشغل الصوت
        soundSource: 'resource://raw/mysound', // 🔹 اسم الملف اللي في res/raw بدون الامتداد
      )
    ],);

  // أول ما التطبيق يفتح اطلب إذن من المستخدم
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString(kUserName);

  runApp(
    MyApp(
      initialScreen: name != null && name.isNotEmpty
          ? const TaskView()
          : const SplashScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget? initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() {
      return GetMaterialApp(
        darkTheme: ThemeData.dark(),
        themeMode: themeController.isDark.value
            ? ThemeMode.dark
            : ThemeMode.light,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        ),
        debugShowCheckedModeBanner: false,
        home: initialScreen!,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
      );
    });


  }
}
