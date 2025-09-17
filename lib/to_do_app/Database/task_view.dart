import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bottom_navig/home.dart';
import '../bottom_navig/profile.dart';
import '../get/task_view_controller.dart';
import 'add_task.dart';
class TaskView extends StatelessWidget {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskViewController>(
      builder: (taskViewState)=>
          SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  taskViewState.getAppBarTitle(),
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                backgroundColor: const Color(0xFF26A69A),
                elevation: 0,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              floatingActionButton: (taskViewState.selectedIndex == 0)
                  ? FloatingActionButton.extended(
                  onPressed: () async {
                    // ننتظر صفحة إضافة مهمة ونشوف هترجع إيه
                    final result = await Get.to(() => AddTask());

                    // نعمل تحديث للمهام في الواجهة
                    taskViewState.getTasks();

                    // لو فعلاً أضاف مهمة
                    if (result == true) {
                      Get.rawSnackbar(
                        messageText: const Text(
                          'تم إضافة المهمة بنجاح!',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: const Color(0xFFEF5350),
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 1),
                        borderRadius: 0,
                        margin: EdgeInsets.zero,
                      );
                    }
                  },
                  backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10,
                icon: const Icon(Icons.add, color: Colors.white),
                label:  Text(
                  'إضافة مهمة',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              )
                  : null,
              body: SafeArea(
                child: taskViewState.selectedIndex == 3
                    ? const Profile()
                    : taskViewState.selectedIndex == 0
                    ? TaskHome(tasksList: taskViewState.tasksList)
                    : taskViewState.buildTaskList(),
              ),
              bottomNavigationBar: BottomNavigationBar(
                showUnselectedLabels: true,
                currentIndex: taskViewState.selectedIndex,
                selectedItemColor: const Color(0xFF26A69A),
                unselectedItemColor: Colors.grey[600],
                backgroundColor: Colors.white,
                elevation: 10,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  taskViewState.selectedIndex = index;
                  taskViewState.update();
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle), label: "المنجزة"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.pending_actions), label: "المعلقة"),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: "البروفايل"),
                ],
              ),
            ),
          ),
    );
  }
}

