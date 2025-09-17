import 'package:flutter/material.dart';
import '../constants/custom_widget.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                WelcomeAppBar(),
                SizedBox(height: 50,),
                WelcomeBody(),
              ],
            ),
          ),
        ));
  }
}




