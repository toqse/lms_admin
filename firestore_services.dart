import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add methods
  Future<void> addCourse(Map<String, dynamic> courseData) async {
    await _db.collection('courses').add(courseData);
  }

  Future<void> addModule(Map<String, dynamic> moduleData) async {
    await _db.collection('modules').add(moduleData);
  }

  Future<void> addLesson(Map<String, dynamic> lessonData) async {
    await _db.collection('lessons').add(lessonData);
  }

  Future<void> addCategory(Map<String, dynamic> lessonData) async {
    await _db.collection('categories').add(lessonData);
  }

  // Fetch methods

//Get Courses
  Stream<List<Map<String, dynamic>>> getCourses() async* {
    // Fetch all courses
    final coursesSnapshot = await _db.collection('courses').get();
    List<Map<String, dynamic>> courses = [];

    for (var courseDoc in coursesSnapshot.docs) {
      final courseData = courseDoc.data();
      final categoryId = courseData['categoryId'];

      // Fetch the category title using the categoryId
      String categoryTitle = 'Uncategorized';
      if (categoryId != null) {
        final categorySnapshot =
            await _db.collection('categories').doc(categoryId).get();

        if (categorySnapshot.exists) {
          categoryTitle = categorySnapshot['title'] ?? 'Uncategorized';
        }
      }

      // Add course data with category title
      courses.add({
        'id': courseDoc.id,
        'title': courseData['title'] ?? 'No Title',
        'description': courseData['description'] ?? 'No Description',
        'instructorId': courseData['instructorId'] ?? 'Unknown',
        'categoryTitle': categoryTitle, // Added category title
        'createdAt': courseData['createdAt'] ?? Timestamp.now(),
      });
    }

    yield courses;
  }

  Stream<List<Map<String, dynamic>>> getCategory() {
    return _db.collection('categories').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => {'id': doc.id, 'title': doc['title']})
        .toList());
  }

  // Method to fetch modules based on courseId
  Stream<List<Map<String, dynamic>>> getModules(String courseId) {
    return _db
        .collection('modules')
        .where('courseId',
            isEqualTo: courseId) // Ensure this field matches exactly
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'title': data['title'] ?? 'No Title',
                'description': data['description'] ?? 'No Description',
                'createdAt': data['createdAt'] ?? Timestamp.now(),
              };
            }).toList());
  }

  // Stream<List<Map<String, dynamic>>> getLessons(String moduleId) {
  //   return _db
  //       .collection('lessons')
  //       .where('moduleId', isEqualTo: moduleId)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((doc) => {'id': doc.id, 'title': doc['title']})
  //           .toList());
  // }

// Fetch lessons for a specific module
  Stream<List<Map<String, dynamic>>> getLessons(String moduleId) {
    return _db
        .collection('lessons')
        .where('moduleId', isEqualTo: moduleId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? 'No Title',
          'content': data['content'] ?? 'No Content',
          'createdAt': data['createdAt'] ?? Timestamp.now(),
          'videoUrl': data['videoUrl'] ?? '',
        };
      }).toList();
    });
  }

  // Add a course to the top picks carousel
  Future<void> addTopPickCourse(Map<String, dynamic> courseData) async {
    // Check if 'courseId' is present and not null
    if (!courseData.containsKey('courseId') || courseData['courseId'] == null) {
      throw Exception(
          "Error: 'courseId' is required to add a top pick course.");
    }

    await _db.collection('top_picks').add(courseData);
  }

  // Get all top-pick courses
  Stream<QuerySnapshot> getTopPickCourses() {
    return _db.collection('top_picks').snapshots();
  }

  // Delete a course from top picks
  Future<void> deleteTopPickCourse(String courseId) async {
    await _db.collection('top_picks').doc(courseId).delete();
  }

  // Add a rating to a course
  Future<void> addRating(String courseId, int rating) async {
    DocumentReference courseRef = _db.collection('top_picks').doc(courseId);

    // Use a transaction to update ratingCount and totalRating atomically
    await _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(courseRef);

      if (!snapshot.exists) return;

      int newRatingCount = (snapshot['ratingCount'] ?? 0) + 1;
      int newTotalRating = (snapshot['totalRating'] ?? 0) + rating;

      transaction.update(courseRef, {
        'ratingCount': newRatingCount,
        'totalRating': newTotalRating,
      });
    });
  }

  // Fetch Top Picks
  Stream<List<Map<String, dynamic>>> getTopPicks() {
    return _db.collection('top_picks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'description': doc['description'],
          'imageUrl': doc['imageUrl'],
        };
      }).toList();
    });
  }
}
