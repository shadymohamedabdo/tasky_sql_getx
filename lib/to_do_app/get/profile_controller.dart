import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskt/to_do_app/constants/constants_url.dart';

class ProfileController extends GetxController {
  var userName = ''.obs;        // اسم المستخدم
  var imagePath = ''.obs;       // مسار الصورة
  var randomQuote = ''.obs;     // الكوتس العشوائي

  final List<String> motivationalQuotes = [
    // عبارات تحفيزية
    "الخطوات الصغيرة كل يوم تؤدي إلى نتائج كبيرة.",
    "لا تنتظر التحفيز، بل ابني الانضباط.",
    "ركز على التقدم وليس الكمال.",
    "سيشكرك مستقبلك على العمل الذي تقوم به اليوم.",
    "مهمة واحدة في كل مرة. استمر في التقدم.",
    "النجاح هو مجموع الجهود الصغيرة المتكررة يومياً.",
    "الانضباط يتغلب على التحفيز كل مرة.",
    "حافظ على الاستمرارية، وستأتي النتائج.",

    // آيات قرآنية
    "﴿وَقُلِ اعْمَلُوا فَسَيَرَى اللَّهُ عَمَلَكُمْ وَرَسُولُهُ وَالْمُؤْمِنُونَ﴾ [التوبة: 105]",
    "﴿وَالَّذِينَ جَاهَدُوا فِينَا لَنَهْدِيَنَّهُمْ سُبُلَنَا﴾ [العنكبوت: 69]",
    "﴿إِنَّ مَعَ الْعُسْرِ يُسْرًا﴾ [الشرح: 6]",
    "﴿فَإِذَا عَزَمْتَ فَتَوَكَّلْ عَلَى اللَّهِ﴾ [آل عمران: 159]",
    "﴿وَمَا تَفْعَلُوا مِنْ خَيْرٍ فَإِنَّ اللَّهَ بِهِ عَلِيمٌ﴾ [البقرة: 215]",
    "﴿وَاصْبِرْ وَمَا صَبْرُكَ إِلَّا بِاللَّهِ﴾ [النحل: 127]",
    "﴿وَتَعَاوَنُوا عَلَى الْبِرِّ وَالتَّقْوَى﴾ [المائدة: 2]",
    "﴿فَمَنْ يَعْمَلْ مِثْقَالَ ذَرَّةٍ خَيْرًا يَرَهُ﴾ [الزلزلة: 7]",
  ];

  @override
  void onInit() {
    super.onInit();
    loadData();
    getRandomQuote();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString(kUserName) ?? '';
    imagePath.value = prefs.getString(kProfileImage) ?? '';
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kProfileImage, pickedFile.path);
      imagePath.value = pickedFile.path;
    }  else {
      Get.rawSnackbar(
        messageText: Center(
          child: Text(
            'لم يتم اختيار صوره',
            style: GoogleFonts.cairo(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFEF5350), // نفس اللون اللي كنت بتحطه
        snackPosition: SnackPosition.BOTTOM,       // علشان يطلع تحت زي SnackBar
        duration: const Duration(seconds: 1),      // نفس مدة الظهور
        borderRadius: 0,                           // علشان يبقى زي الـ SnackBar العادي
        margin: EdgeInsets.zero,                   // بدون مسافة فوق أو تحت
      );
    }
  }

  void getRandomQuote() {
    randomQuote.value =
    motivationalQuotes[Random().nextInt(motivationalQuotes.length)];
  }
}
