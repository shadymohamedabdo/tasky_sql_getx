import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Database/task_view.dart';
import 'constants_url.dart';


   /// Welcome Screen
class WelcomeAppBar extends StatelessWidget {
  const WelcomeAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(splashImage, height: 42),
          SizedBox(width: 10,),
          TextPlusJakartaSans(title: 'تاسكي', fontSize: 28,)
        ],
      ),
    );
  }
}
class WelcomeBody extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
   WelcomeBody({super.key});
  void dispose() {
    nameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextPlusJakartaSans(title: 'أهلاً بك في تاسكي', fontSize: 24,),
          TextPlusJakartaSans(title: 'رحلتك للإنتاجية تبدأ من هنا', fontSize: 16,),
          SizedBox(height: 21,),
          SvgPicture.asset(welcomeImage, height: 204, width: 215),
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextPoppinsW400(title: 'الاسم كامل', fontSize: 16,color: Colors.blue,),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child:
              CustomTextForm(controller: nameController, validateText: 'من فضلك ادخل اسمك', hintText: 'ادخل اسمك من فضلك')
          ),
          CustomElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()){
                await setUserName();
              }
            },
            child: TextPoppinsW400(title: 'يلا نبدأ',),

          )
        ],
      ),
    );

  }
  Future<void> setUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(kUserName, nameController.value.text);
    Get.offAll(TaskView());
  }

}

       /// Add&Edit Task
class AddTittle extends StatelessWidget {
  final TextEditingController controllerTitle;

  const AddTittle({super.key, required this.controllerTitle});

  @override
  Widget build(BuildContext context) {
    return CustomTextForm(controller: controllerTitle, validateText: 'من فضلك ادخل المهمه', hintText: 'العنوان', prefixIcon: Icon(Icons.title)
    );
  }
}
class AddDate extends StatelessWidget {
  final TextEditingController controllerDate;
  const AddDate({super.key, required this.controllerDate});

  @override
  Widget build(BuildContext context) {
    return CustomTextForm(
      readOnly: true,
      prefixIcon: Icon(Icons.watch_later),
      onTap: () async {
        final value = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030, 5, 3),
        );
        if (value != null) {
          // نحفظ التاريخ بصيغة يسهل قراءتها
          controllerDate.text = DateFormat('yyyy-MM-dd').format(value);
        }
      },
      controller: controllerDate,
      validateText: 'من فضلك ادخل التاريخ',
      hintText: 'التاريخ',
    );
  }
}
class AddTime extends StatelessWidget {
  final TextEditingController controllerTime;
  const AddTime({super.key, required this.controllerTime});

  @override
  Widget build(BuildContext context) {
    return CustomTextForm(
      readOnly: true,
      prefixIcon: Icon(Icons.timer),
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((value) {
          if (value != null) {
            // نحفظ الوقت بصيغة 24 ساعة
            final now = DateTime.now();
            final dt = DateTime(
                now.year, now.month, now.day, value.hour, value.minute);
            controllerTime.text = DateFormat('HH:mm').format(dt);
          }
        });
      },
      controller: controllerTime,
      validateText: 'من فضلك ادخل الوقت',
      hintText: 'الوقت',
    );
  }
}
class AddSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChange;
  const AddSwitch({super.key, required this.value, this.onChange});

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        TextPoppinsW400(fontSize: 18.0, title: 'انجاز التاسك',),
        Spacer(),
        Switch(
          activeTrackColor: Color(0xff15B86C),
          value: value,
          onChanged:onChange,
          activeThumbColor: Colors.white,
        ),
      ],
    );
  }
}

/// Custom Widget
class TextPoppinsW400 extends StatelessWidget {
  final double fontSize ;
  final String title;
  final Color? color;
  const TextPoppinsW400({super.key, required this.title,this.fontSize = 20.0, this.color, });
  @override
  Widget build(BuildContext context) {
    return   Text(title,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
          color: color
      ),);

  }
}
class TextPlusJakartaSans extends StatelessWidget {
  final String title;
  final double? fontSize ;

  const TextPlusJakartaSans({super.key, required this.title,this.fontSize });
  @override
  Widget build(BuildContext context) {
    return   Text(title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: fontSize,

        )
    );

  }
}
class CustomElevatedButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onPressed;
  const CustomElevatedButton({super.key, this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor:  Color(0xff15B86C),
          fixedSize: Size(343, 40),
          foregroundColor: Colors.white
      ), child:child,
    );
  }
}
class CustomTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String validateText;
  final String hintText;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final bool? readOnly;
  const CustomTextForm({super.key, required this.controller, required this.validateText, required this.hintText,this.onTap, this.prefixIcon,this.readOnly});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ?? false,
      onTap:onTap ,
      validator: (value){
        if (value!.isEmpty){
          return validateText;
        }
        return null;
      },
      controller: controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color(0xff6D6D6D)
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none
          )
      ),
    );
  }
}






