import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms_admin01/view/firestore_services.dart';
import 'package:intl/intl.dart';
import 'package:lms_admin01/view/add_modules.dart';

class ModuleListScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  ModuleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modules by Course'),
        backgroundColor: Colors.blue.shade700,
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
            padding: EdgeInsets.all(12),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              final courseId = course['id'];
              final courseTitle = course['title'] ?? 'No Title';

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.book, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text(
                        courseTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: firestoreService.getModules(courseId),
                      builder: (context, moduleSnapshot) {
                        if (moduleSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!moduleSnapshot.hasData ||
                            moduleSnapshot.data!.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "No modules available for $courseTitle",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          );
                        }

                        final modules = moduleSnapshot.data!;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: modules.length,
                          itemBuilder: (context, moduleIndex) {
                            final module = modules[moduleIndex];
                            final createdAt = module['createdAt'] is Timestamp
                                ? DateFormat.yMMMd().format(
                                    (module['createdAt'] as Timestamp).toDate())
                                : 'Unknown Date';

                            return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
                              color: Colors.grey.shade100,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: Icon(Icons.folder,
                                    color: Colors.deepPurple),
                                title: Text(
                                  module['title'] ?? 'No Title',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Created At: $createdAt",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        module['description'] ??
                                            'No Description',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
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
              builder: (context) => ModuleScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        tooltip: 'Add New Module',
      ),
    );
  }
}
