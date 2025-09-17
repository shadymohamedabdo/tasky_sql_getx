import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../constants/constants_url.dart';
import '../get/theme_controller.dart';
import '../get/profile_controller.dart';
class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final profileState = Get.find<ProfileController>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(() => IconButton(
            icon: Icon(themeController.isDark.value
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () => themeController.toggleTheme(),
          )),
        ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // صورة البروفايل
            Stack(
              children: [
                Obx(() => CircleAvatar(
                  radius: 100,
                  backgroundImage: profileState.imagePath.value.isNotEmpty
                      ? FileImage(File(profileState.imagePath.value))
                      : null,
                  backgroundColor: Colors.grey[200],
                  child: profileState.imagePath.value.isEmpty
                      ?
                  ClipOval(
                    child: SvgPicture.asset(
                      profileImage,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                      : null,
                )),
                Positioned(
                  bottom: 0,
                  right: 8,
                  child: InkWell(
                    onTap: profileState.pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF26A69A),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child:
                      const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // الاسم
          Text(
            profileState.userName.value,
            style: const TextStyle(fontSize: 20),
          ),

      // الكوتس
            Obx(() => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              color: Colors.deepOrangeAccent,
              margin:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    profileState.randomQuote.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            )),
            ElevatedButton(
              onPressed: () {
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    icon: kNotificationIcon,
                    id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
                    channelKey: 'tasks_channel',
                    title: 'إشعار تجريبي',
                    body: 'الإشعار شغال الحمد لله 🎉',
                  ),
                );
              },
              child: Text('إشعار دلوقتي'),
            )
          ],
        ),
      ),
    );
  }
}
