import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Profile?> getCurrentProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore
          .collection('profiles')
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;
      return Profile.fromJson(doc.data()!);
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore
          .collection('profiles')
          .doc(user.uid)
          .update({
        ...updates,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
} 