import 'package:flutter/material.dart';
import 'package:lms_admin01/view/firestore_services.dart';
import 'package:lms_admin01/widgets/custom_textfield.dart';
import 'package:lms_admin01/widgets/dropdown.dart';

class LessonScreen extends StatefulWidget {
  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();

  String? selectedCourseId;
  String? selectedModuleId;
  List<Map<String, dynamic>> courseOptions = [];
  List<Map<String, dynamic>> moduleOptions = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    firestoreService.getCourses().listen((courses) {
      setState(() {
        courseOptions = courses;
      });
    });
  }

  void loadModules(String courseId) {
    firestoreService.getModules(courseId).listen((modules) {
      setState(() {
        moduleOptions = modules;
        selectedModuleId = null;
      });
    });
  }

  void addLesson() async {
    if (selectedCourseId == null || selectedModuleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both a course and a module.")),
      );
      return;
    }

    final lessonData = {
      'moduleId': selectedModuleId,
      'title': titleController.text.trim(),
      'content': contentController.text.trim(),
      'videoUrl': videoUrlController.text.trim(),
      'createdAt': DateTime.now(),
    };

    try {
      await firestoreService.addLesson(lessonData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lesson added successfully!")),
      );

      // Clear form fields
      titleController.clear();
      contentController.clear();
      videoUrlController.clear();
      setState(() {
        selectedCourseId = null;
        selectedModuleId = null;
        moduleOptions.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add lesson: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Lesson'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                "Create New Lesson",
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
                    loadModules(value!);
                  });
                },
              ),
              SizedBox(height: 15),
              DropdownSelector(
                label: 'Module',
                selectedValue: selectedModuleId,
                items: moduleOptions,
                onChanged: (value) {
                  setState(() {
                    selectedModuleId = value;
                  });
                },
              ),
              SizedBox(height: 15),
              CustomTextField(
                controller: titleController,
                labelText: 'Lesson Title',
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: contentController,
                labelText: 'Content',
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: videoUrlController,
                labelText: 'Video URL',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addLesson,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Add Lesson',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
