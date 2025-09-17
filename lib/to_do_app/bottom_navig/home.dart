import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants_url.dart';

class TaskHome extends StatelessWidget {

  final List<Map<String, dynamic>> tasksList;
  const TaskHome({super.key, required this.tasksList});

  @override
  Widget build(BuildContext context) {
    int completed = tasksList.where((t) => t[kPriority] == 1).length;
    int pending = tasksList.where((t) => t[kPriority] == 0).length;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.1), width: 1),
                ),
                elevation: 3,
                shadowColor: Colors.grey.withValues(alpha: 0.15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xFF26A69A), // تدرج الأخضر الزمردي
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إحصائيات المهام',
                          style: GoogleFonts.cairo(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatRow("✅ المهام المكتملة", completed, const Color(0xFF4CAF50),), // أخضر داكن متناسق
                        const SizedBox(height: 12),
                        const Divider(thickness: 1, color: Colors.grey),
                        const SizedBox(height: 12), _buildStatRow("⏳ المهام غير المكتملة", pending, const Color(0xFF26A69A),), // أخضر زمردي
                        const SizedBox(height: 12),
                        const Divider(thickness: 1, color: Colors.grey),
                        const SizedBox(height: 12), _buildStatRow("📋 كل المهام", tasksList.length, Colors.red),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, int value, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15), // خلفية خفيفة متناسقة
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
            ),
            child: Text(
              value.toString(),
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}