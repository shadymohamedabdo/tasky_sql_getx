import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/custom_widget.dart';
import '../get/edit_controller.dart';

class EditTask extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  EditTask({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final editState = Get.put(EditController());

    // /// نملأ البيانات مرة واحدة بس بدل ما تكرر ما كل رن
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   editState.initData(
    //     id: id,
    //     taskName: taskName,
    //     taskTime: taskTime,
    //     taskDate: taskDate,
    //     priority: priority,
    //   );
    // });
    /// تحميل البيانات من Get.arguments بعد البناء
    WidgetsBinding.instance.addPostFrameCallback((_) {
      editState.loadDataFromArguments();
    });

    return Scaffold(
      appBar: AppBar(title: TextPoppinsW400(title: 'تعديل التاسك')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                /// اسم التاسك
                AddTittle(controllerTitle: editState.taskNameController),
                const SizedBox(height: 20),

                /// التاريخ
                AddDate(controllerDate: editState.dateController),
                const SizedBox(height: 20),

                /// الوقت
                AddTime(controllerTime: editState.timeController),
                const SizedBox(height: 20),

                /// السويتش
                Obx(() => AddSwitch(
                  value: editState.isChecked.value,
                  onChange: (value) => editState.isChecked.value = value,
                )),
                const SizedBox(height: 80),

                /// زرار تعديل
                ElevatedButton.icon(
                  onPressed: () async {
                    await editState.updateDatabase(_formKey);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff15B86C),
                    fixedSize: const Size(343, 40),
                    foregroundColor: Colors.white,
                  ),
                  label: TextPoppinsW400(
                    title: 'تعديل',
                    fontSize: 16.0,
                  ),
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
