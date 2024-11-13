import 'package:flutter/material.dart';

import 'package:lms_admin01/view/course_listscreen.dart';
import 'package:lms_admin01/view/lesson_listscreen.dart';
import 'package:lms_admin01/view/module_listscreen.dart';
import 'package:lms_admin01/view/toppicks_listscreen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: GridView(
        padding: EdgeInsets.all(20.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          AdminOption(
            title: 'Courses',
            icon: Icons.school,
            color: Colors.orange.shade600,
            screen: CourseListScreen(),
          ),
          AdminOption(
            title: 'Modules',
            icon: Icons.layers,
            color: Colors.blue.shade600,
            screen: ModuleListScreen(),
          ),
          AdminOption(
            title: 'Lessons',
            icon: Icons.video_library,
            color: Colors.purple.shade600,
            screen: LessonListScreen(),
          ),
          AdminOption(
            title: 'Top Picks',
            icon: Icons.star,
            color: Colors.red.shade600,
            screen: TopPicksListScreen(),
          ),
        ],
      ),
    );
  }
}

class AdminOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget screen;

  AdminOption({
    required this.title,
    required this.icon,
    required this.color,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8,
        shadowColor: color.withOpacity(0.4),
        color: color.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
