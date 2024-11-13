import 'package:flutter/material.dart';
import 'package:lms_admin01/view/firestore_services.dart';
import 'package:lms_admin01/widgets/custom_textfield.dart';
import 'package:lms_admin01/widgets/dropdown.dart';

class ModuleScreen extends StatefulWidget {
  @override
  _ModuleScreenState createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedCourseId;
  List<Map<String, dynamic>> courseOptions = [];

  @override
  void initState() {
    super.initState();
    firestoreService.getCourses().listen((courses) {
      setState(() {
        courseOptions = courses;
      });
    });
  }

  void addModule() async {
    if (selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a course.")),
      );
      return;
    }

    final moduleData = {
      'courseId': selectedCourseId,
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'createdAt': DateTime.now(),
    };

    try {
      await firestoreService.addModule(moduleData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Module added successfully!")),
      );
      titleController.clear();
      descriptionController.clear();
      setState(() {
        selectedCourseId = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add module: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Module'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
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
          children: [
            Text(
              "Create New Module",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            SizedBox(height: 20),
            DropdownSelector(
              label: 'Course',
              selectedValue: selectedCourseId,
              items: courseOptions,
              onChanged: (value) {
                setState(() {
                  selectedCourseId = value;
                });
              },
            ),
            SizedBox(height: 15),
            CustomTextField(
              controller: titleController,
              labelText: 'Module Title',
            ),
            SizedBox(height: 15),
            CustomTextField(
              controller: descriptionController,
              labelText: 'Description',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addModule,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Add Module',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
