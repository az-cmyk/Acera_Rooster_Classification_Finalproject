import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> logClassification({
    required String breedName,
    required double confidence,
    required List<dynamic> top3,
  }) async {
    try {
      await _db.collection('classifications').add({
        'breed': breedName,
        'confidence': confidence,
        'top_matches': top3,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': defaultTargetPlatform.toString(),
      });
      debugPrint('Classification logged to Firestore');
    } catch (e) {
      debugPrint('Error logging to Firestore: $e');
    }
  }
}
