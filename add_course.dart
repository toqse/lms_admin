import 'package:flutter/material.dart';
import 'package:lms_admin01/view/firestore_services.dart';
import 'package:lms_admin01/view/add_categories.dart';
import 'package:lms_admin01/widgets/custom_textfield.dart';
import 'package:lms_admin01/widgets/dropdown.dart';

class CourseScreen extends StatefulWidget {
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController instructorController = TextEditingController();

  String? selectedCategoryId;
  List<Map<String, dynamic>> categoryOptions = [];

  @override
  void initState() {
    super.initState();
    firestoreService.getCategory().listen((categories) {
      setState(() {
        categoryOptions = categories;
      });
    });
  }

  void addCategory() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryScreen(),
        ));
  }

  void addCourse() async {
    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a category.")),
      );
      return;
    }

    final courseData = {
      'categoryId': selectedCategoryId,
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'instructorId': instructorController.text.trim(),
      'createdAt': DateTime.now(),
    };

    try {
      await firestoreService.addCourse(courseData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Course added successfully!")),
      );
      titleController.clear();
      descriptionController.clear();
      instructorController.clear();
      setState(() {
        selectedCategoryId = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add course: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
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
                "Create New Course",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: titleController,
                labelText: 'Course Title',
              ),
              SizedBox(height: 15),
              CustomTextField(
                controller: descriptionController,
                labelText: 'Description',
              ),
              SizedBox(height: 15),
              CustomTextField(
                controller: instructorController,
                labelText: 'Instructor ID',
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: DropdownSelector(
                      label: 'Category',
                      selectedValue: selectedCategoryId,
                      items: categoryOptions,
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryId = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.blue),
                    onPressed: addCategory,
                    tooltip: 'Add New Category',
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addCourse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Add Course',
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
