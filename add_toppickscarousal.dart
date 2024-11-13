import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms_admin01/view/firestore_services.dart';

class AdminTopPicksScreen extends StatefulWidget {
  @override
  _AdminTopPicksScreenState createState() => _AdminTopPicksScreenState();
}

class _AdminTopPicksScreenState extends State<AdminTopPicksScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedCourseId;
  List<Map<String, dynamic>> courses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  void _fetchCourses() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('courses').get();
    setState(() {
      courses = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'] ?? 'No Title',
        };
      }).toList();
    });
  }

  void addTopPickCourse() async {
    if (selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a course")),
      );
      return;
    }

    final courseData = {
      'courseId': selectedCourseId,
      'title': courses
          .firstWhere((course) => course['id'] == selectedCourseId)['title'],
      'description': descriptionController.text.trim(),
      'imageUrl': imageUrlController.text.trim(),
      'isTopPick': true,
      'totalRating': 0,
      'ratingCount': 0,
      'createdAt': Timestamp.now(),
    };

    await firestoreService.addTopPickCourse(courseData);
    _clearForm();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Course added to Top Picks!")));
  }

  void _clearForm() {
    setState(() {
      selectedCourseId = null;
      imageUrlController.clear();
      descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Top Pick Course"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        constraints: BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Add Top Pick Course",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedCourseId,
              items: courses.map((course) {
                return DropdownMenuItem<String>(
                  value: course['id'],
                  child: Text(course['title']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourseId = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Select Course",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Course Description",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(
                labelText: "Image URL",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: addTopPickCourse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Add to Top Picks",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
