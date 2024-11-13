import 'package:flutter/material.dart';
import 'package:lms_admin01/view/firestore_services.dart';
import 'package:lms_admin01/widgets/custom_textfield.dart';

class CategoryScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();

  void addCategory(BuildContext context) async {
    try {
      // Prepare the data
      final categoryData = {
        'title': titleController.text.trim(),
        'createdAt': DateTime.now(),
      };

      // Call Firestore service to add the category
      await FirestoreService().addCategory(categoryData);

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Category added successfully!"),
          backgroundColor: Colors.blue.shade700,
        ),
      );

      // Clear the text field
      titleController.clear();
    } catch (e) {
      // Show error snackbar if there's an exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add category: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Categories'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: BoxConstraints(maxWidth: 400),
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
                "Create New Category",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: titleController,
              labelText: 'Category Title',
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => addCategory(context), // Pass context here
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Add Category',
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
