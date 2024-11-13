import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms_admin01/view/firestore_services.dart';
import 'package:lms_admin01/view/add_lessons.dart';

class LessonListScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Lessons by Course'),
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getCourses(),
        builder: (context, courseSnapshot) {
          if (courseSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!courseSnapshot.hasData || courseSnapshot.data!.isEmpty) {
            return Center(child: Text("No courses available"));
          }

          final courses = courseSnapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: courses.length,
            itemBuilder: (context, courseIndex) {
              final course = courses[courseIndex];
              final courseId = course['id'];
              final courseTitle = course['title'] ?? 'No Title';

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Text(
                    courseTitle,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.book, color: Colors.blueAccent),
                  children: [
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: firestoreService.getModules(courseId),
                      builder: (context, moduleSnapshot) {
                        if (!moduleSnapshot.hasData ||
                            moduleSnapshot.data!.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("No modules available for this course"),
                          );
                        }

                        final modules = moduleSnapshot.data!;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: modules.length,
                          itemBuilder: (context, moduleIndex) {
                            final module = modules[moduleIndex];
                            final moduleId = module['id'];
                            final moduleTitle = module['title'] ?? 'No Title';

                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  moduleTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                leading: Icon(Icons.folder,
                                    color: Colors.deepPurple),
                                children: [
                                  StreamBuilder<List<Map<String, dynamic>>>(
                                    stream:
                                        firestoreService.getLessons(moduleId),
                                    builder: (context, lessonSnapshot) {
                                      if (!lessonSnapshot.hasData ||
                                          lessonSnapshot.data!.isEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                              "No lessons available for this module"),
                                        );
                                      }

                                      final lessons = lessonSnapshot.data!;

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: lessons.length,
                                        itemBuilder: (context, lessonIndex) {
                                          final lesson = lessons[lessonIndex];
                                          final lessonTitle =
                                              lesson['title'] ?? 'No Title';
                                          final lessonContent =
                                              lesson['content'] ?? 'No Content';
                                          final createdAt =
                                              lesson['createdAt'] is Timestamp
                                                  ? DateFormat.yMMMd().format(
                                                      (lesson['createdAt']
                                                              as Timestamp)
                                                          .toDate())
                                                  : 'Unknown Date';

                                          return ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                            title: Text(
                                              lessonTitle,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              lessonContent,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                            trailing: Text(
                                              'Created: $createdAt',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            leading: Icon(
                                                Icons.play_circle_fill,
                                                color: Colors.orangeAccent),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        tooltip: 'Add New Lesson',
      ),
    );
  }
}
