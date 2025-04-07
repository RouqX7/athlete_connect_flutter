import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/profile.dart';
import './app_check_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthResponse {
  final bool success;
  final String message;
  final int status;
  final Map<String, dynamic>? data;

  AuthResponse({
    required this.success,
    required this.message,
    required this.status,
    this.data,
  });
}

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _baseUrl = 'http://localhost:3300'; 
  final AppCheckService _appCheckService = AppCheckService();

  // Sign in with email and password
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user profile from Firestore
      final profileDoc = await _firestore
          .collection('profiles')
          .doc(userCredential.user!.uid)
          .get();

      if (!profileDoc.exists) {
        throw Exception('Profile not found');
      }

      return AuthResponse(
        success: true,
        message: 'Login successful',
        status: 200,
        data: {
          'uid': userCredential.user!.uid,
          'email': email,
          'profile': profileDoc.data(),
        },
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString(),
        status: 500,
      );
    }
  }

  Future<AuthResponse> register(Profile profile, String password) async {
    try {
      // Create Firebase user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: profile.user.authInfo.email,
        password: password,
      );

      // Update profile with the new UID
      final updatedProfile = Profile(
        accountStatus: profile.accountStatus,
        lastUpdated: profile.lastUpdated,
        preferences: profile.preferences,
        user: User(
          authInfo: AuthInfo(
            createdAt: profile.user.authInfo.createdAt,
            email: profile.user.authInfo.email,
            lastLogin: profile.user.authInfo.lastLogin,
            phone: profile.user.authInfo.phone,
            secureLogin: profile.user.authInfo.secureLogin,
            uid: userCredential.user!.uid,
            username: profile.user.authInfo.username,
          ),
          bio: profile.user.bio,
          image: profile.user.image,
          isAgreed: profile.user.isAgreed,
          location: profile.user.location,
          socialLinks: profile.user.socialLinks,
          website: profile.user.website,
        ),
        verified: profile.verified,
      );

      // Save profile to Firestore
      await _firestore
          .collection('profiles')
          .doc(userCredential.user!.uid)
          .set(updatedProfile.toJson());

      return AuthResponse(
        success: true,
        message: 'Registration successful',
        status: 200,
        data: {
          'uid': userCredential.user!.uid,
          'email': profile.user.authInfo.email,
        },
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString(),
        status: 500,
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user profile
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
} 