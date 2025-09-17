import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Database/database_helper.dart.dart';

class EditController extends GetxController {
  /// Controllers للحقول
  final taskNameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  @override
  void onClose() {
    taskNameController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }

  /// القيم القابلة للملاحظة (Rx)
  var isChecked = true.obs;

  /// الـ id الخاص بالتاسك
  late int id;

  /// init data
  ///  give it old value before Editing
  // void initData({
  //   required int id,
  //   required String taskName,
  //   required String taskTime,
  //   required String taskDate,
  //   required int priority,
  // }) {
  //   this.id = id;
  //   taskNameController.text = taskName;
  //   timeController.text = taskTime;
  //   dateController.text = taskDate;
  //   isChecked.value = priority == 1;
  // }
  /// نقرأ البيانات من Get.arguments
  /// بدل ما نعمل باراميتر زي اللي فوق
  void loadDataFromArguments() {
    final args = Get.arguments as Map<String, dynamic>;
    id = args['id'];
    taskNameController.text = args['taskName'];
    timeController.text = args['taskTime'];
    dateController.text = args['taskDate'];
    isChecked.value = args['priority'] == 1;
  }

  /// تحديث البيانات في الداتابيز
  Future<void> updateDatabase(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      var task = {
        "taskName": taskNameController.text,
        "taskDate": dateController.text,
        "taskTime": timeController.text,
        "priority": isChecked.value ? 1 : 0,
      };

      await DatabaseHelper.instance.updateTask(id, task);
      Get.back(result: true);
    }
  }


}
