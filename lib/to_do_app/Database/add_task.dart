import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constants/constants_url.dart';
import '../constants/custom_widget.dart';
import 'database_helper.dart.dart';
class AddTask extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  final TextEditingController taskName = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final bool isChecked = false;
   AddTask({super.key});

  void dispose() {
    taskName.dispose();
    dateController.dispose();
    timeController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('اضافه مهمه')),
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 30),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                AddTittle(controllerTitle: taskName,),
                SizedBox(height: 20,),
                AddDate(controllerDate:dateController, ),
                SizedBox(height: 20,),
                AddTime(controllerTime: timeController,),
                SizedBox(height: 20,),
                AddSwitch(
                  value: isChecked,
                ),
                SizedBox(height: 30,),

                ElevatedButton.icon(
                  onPressed: () async {
                    await addDatabase(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0xff15B86C),
                      fixedSize: Size(343, 40),
                      foregroundColor: Colors.white
                  ),
                  label: Text('اضافه تاسك',style: TextStyle(fontSize: 16.0)),
                  icon: Icon(Icons.add),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  addDatabase(BuildContext context) async {
    if (_key.currentState!.validate()) {
      // 🔹 جهز بيانات المهمة
      var task = {
        "taskName": taskName.text,
        "taskDate": dateController.text,
        "taskTime": timeController.text,
        "priority": isChecked ? 1 : 0,
      };

      // 🔹 إدخال المهمة للـ DB
      int taskId = await DatabaseHelper.instance.insertTask(task);

      // 🔹 تحويل التاريخ والوقت لـ DateTime
      DateTime taskDateTime = DateFormat("yyyy-MM-dd HH:mm").parse(
        "${task['taskDate']} ${task['taskTime']}",
      );

      // 🔹 جدولة الإشعار
      scheduleTaskNotification(
        id: taskId,
        title: taskName.text,
        body: 'يلا يا بطل عندك مهمه ',
        dateTime: taskDateTime,
      );

      Get.back(result:true);
    }
  }

  Future<void> scheduleTaskNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? soundPath,
  }) async {
    NotificationContent content = NotificationContent(
      icon: kNotificationIcon,
      id: id,
      channelKey: kChannelKey,
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,

    );

    await AwesomeNotifications().createNotification(
      content: content,
      schedule: NotificationCalendar(

        year: dateTime.year,
        month: dateTime.month,
        day: dateTime.day,
        hour: dateTime.hour,
        minute: dateTime.minute,
        second: 0,
        millisecond: 0,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        repeats: false,
      ),
    );
  }
}
