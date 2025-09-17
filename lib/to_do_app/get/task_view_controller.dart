import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Database/database_helper.dart.dart';
import '../Database/edit_task.dart';
class TaskViewController extends GetxController{

  List<Map<String, dynamic>> tasksList = [];
  int selectedIndex = 3;

  List<Map<String, dynamic>> get filteredTasks {
    if (selectedIndex == 1) {
      return tasksList.where((taskDone) => taskDone['priority'] == 1).toList();
    } else if (selectedIndex == 2) {
      return tasksList.where((taskWait) => taskWait['priority'] == 0).toList();
    }
    return tasksList;
  }
  Future<void> getTasks() async {
    final data = await DatabaseHelper.instance.getAllTasks();
    tasksList = data;
    update();
  }
  Widget buildTaskList() {
    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selectedIndex == 1
                  ? Icons.celebration_outlined
                  : Icons.inbox_outlined,
              size: 64,
              color: const Color(0xFF718096),
            ),
            const SizedBox(height: 16),
            Text(
              selectedIndex == 1 ? "لا توجد مهام منجزة" : "لا توجد مهام معلقة",
              style: const TextStyle(
                color: Color(0xFF718096),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              selectedIndex == 1
                  ? "ابدأ بإنجاز بعض المهام!"
                  : "أضف بعض المهام الجديدة",
              style: TextStyle(
                color: const Color(0xFF718096).withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filteredTasks.length,
      itemBuilder: (BuildContext context, int index) {
        final task = filteredTasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          shadowColor: Colors.black12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  task['priority'] == 1
                      ? const Color(0xFF66BB6A).withValues(alpha: 0.05)
                      : const Color(0xFFFF7043).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task['taskName'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: task['priority'] == 1
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: task['priority'] == 1
                              ? const Color(0xFF66BB6A).withValues(alpha: 0.2)
                              : const Color(0xFFFF7043).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task['priority'] == 1 ? "انتهت" : "قيد التنفيذ",
                          style: TextStyle(
                            fontSize: 12,
                            color: task['priority'] == 1
                                ? const Color(0xFF66BB6A)
                                : const Color(0xFFFF7043),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

// ✅ عرض التاريخ والوقت تحت بعض
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['taskDate'],
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task['taskTime'],
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 20, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: task['priority'] == 1,
                            activeColor: const Color(0xFF66BB6A),
                            onChanged: (value) async {
                              int newPriority = value! ? 1 : 0;
                              await DatabaseHelper.instance
                                  .updateTaskPriority(task['id'], newPriority);
                              getTasks();
                              Get.rawSnackbar(
                                messageText: Text(
                                  value ? 'تم تعليم المهمة كمنجزة!' : 'تم إلغاء تعليم المهمة!',
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: value
                                    ? const Color(0xFF66BB6A) // نفس اللون الأخضر
                                    : const Color(0xFFFF7043), // نفس اللون البرتقالي
                                snackPosition: SnackPosition.BOTTOM,       // تحت زي SnackBar العادي
                                duration: const Duration(seconds: 1),      // نفس مدة SnackBar
                                borderRadius: 0,                           // علشان يبقى مربع زي SnackBar العادي
                                margin: EdgeInsets.zero,                   // من غير مسافات
                              );

                            },
                          ),
                          const Text("تمت"),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color(0xFF42A5F5)),
                            onPressed: () async {
                              final result =await
                              Get.to(
                                    () => EditTask(),
                                arguments: {
                                  'id': task['id'],
                                  'taskName': task['taskName'],
                                  'taskTime': task['taskTime'],
                                  'taskDate': task['taskDate'],
                                  'priority': task['priority'],
                                },
                              );

                              if (result == true) {
                                getTasks();
                                Get.rawSnackbar(
                                  messageText: const Text(
                                    'تم تعديل المهمة بنجاح!',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.green, // نفس اللون اللي كنت بتحطه
                                  snackPosition: SnackPosition.BOTTOM,       // علشان يطلع تحت زي SnackBar
                                  duration: const Duration(seconds: 1),      // نفس مدة الظهور
                                  borderRadius: 0,                           // علشان يبقى زي الـ SnackBar العادي
                                  margin: EdgeInsets.zero,                   // بدون مسافة فوق أو تحت
                                );

                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color(0xFFEF5350)),
                            onPressed: () async {
                              Get.defaultDialog(
                                title: "تأكيد الحذف",
                                titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                radius: 15,
// هنا المحتوى + الأزرار بالظبط زي الـ AlertDialog
                                content: Column(
                                  children: [
                                    const Text("هل أنت متأكد من حذف هذه المهمة؟"),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
// زرار إلغاء
                                        TextButton(
                                          child: const Text("إلغاء"),
                                          onPressed: () {
                                            Get.back();
                                          },
                                        ),
                                        const SizedBox(width: 10),
// زرار حذف (أحمر)
                                        TextButton(
                                          child: const Text(
                                            "حذف",
                                            style: TextStyle(
                                              color: Color(0xFFEF5350), // نفس اللون الأحمر اللي عندك
                                            ),
                                          ),
                                          onPressed: () async {
                                            await DatabaseHelper.instance.deleteTask(task['id']);
                                            Get.back(); // يقفل الديالوج
                                            getTasks();
                                            Get.rawSnackbar(
                                              messageText: const Text(
                                                'تم حذف المهمة بنجاح!',
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: const Color(0xFFEF5350), // نفس اللون اللي كنت بتحطه
                                              snackPosition: SnackPosition.BOTTOM,       // علشان يطلع تحت زي SnackBar
                                              duration: const Duration(seconds: 1),      // نفس مدة الظهور
                                              borderRadius: 0,                           // علشان يبقى زي الـ SnackBar العادي
                                              margin: EdgeInsets.zero,                   // بدون مسافة فوق أو تحت
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );

                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String getAppBarTitle() {
    switch (selectedIndex) {
      case 0:
        return "المهام";
      case 1:
        return "المهام المنجزة";
      case 2:
        return "المهام المعلقة";
      case 3:
        return "الملف الشخصي";
      default:
        return "المهام";
    }
  }
  @override
  void onInit(){
    getTasks();

    super.onInit();


  }
}