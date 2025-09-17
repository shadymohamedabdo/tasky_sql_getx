import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:taskt/to_do_app/inital/welcome.dart';
import '../constants/constants_url.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const WelcomeScreen());
    });
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.5,
                    colors: [
                      Colors.green.shade500,
                    const Color(0xff181818),
                    ]
                )
            ),
          ),
          Center(child: SvgPicture.asset(splashImage,height: 120,)),
          Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    center: Alignment.bottomRight,
                    radius: 1.2,
                    colors: [
                      Colors.green.shade500,
                      Colors.black54,
                    ]
                )
            ),
          ),
        ],
      ),
    );
  }
}
