import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const themeKey = "isDarkMode";
  RxBool isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDark.value = prefs.getBool(themeKey) ?? false;
    Get.changeTheme(isDark.value ? ThemeData.dark() : ThemeData.light());
  }

  void toggleTheme() async {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? ThemeData.dark() : ThemeData.light());

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeKey, isDark.value);
  }
}
