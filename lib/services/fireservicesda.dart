import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServiceDed {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save label options to Firebase
  Future<void> saveLabelOptions(List<String> labels) async {
    try {
      await _db.collection('labelOptions').doc('default').set({
        'labels': labels,
      });
    } catch (e) {
      print("Error saving label options: $e");
    }
  }

  // Fetch label options from Firebase
  Future<List<String>> fetchLabelOptions() async {
    try {
      DocumentSnapshot snapshot =
          await _db.collection('labelOptions').doc('default').get();
      if (snapshot.exists) {
        List<dynamic> labels = snapshot['labels'];
        return labels.map((label) => label as String).toList();
      } else {
        return []; // Return an empty list if not found
      }
    } catch (e) {
      print("Error fetching label options: $e");
      return [];
    }
  }
}
