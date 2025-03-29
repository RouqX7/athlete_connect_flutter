import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/profile.dart';
import './app_check_service.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _baseUrl = 'http://localhost:3300'; // Your Node.js server URL
  final AppCheckService _appCheckService = AppCheckService();

  // Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      // Firebase Authentication
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get Firebase ID token
      final idToken = await userCredential.user?.getIdToken();

      // Call your backend API
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: json.encode({
          'email': email,
          'password': password,
          // Add any additional data your API needs
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to authenticate with backend');
      }

      return userCredential;
    } catch (e) {
      print('Error during sign in: $e');
      rethrow;
    }
  }

  Future<AuthResponse> register(Profile profile, String password) async {
    try {
      // Get valid App Check token
      final appCheckToken = await _appCheckService.getValidToken();
      if (appCheckToken == null) {
        return AuthResponse(
          success: false,
          message: 'Failed to verify app authenticity',
          status: 400,
        );
      }

      // Create the user with Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: profile.email,
        password: password,
      );

      // Get the token
      final token = await userCredential.user?.getIdToken();
      final uid = userCredential.user?.uid;

      // Prepare the registration data
      final registrationData = {
        ...profile.toJson(),
        'password': password,
      };

      // Call your backend API with both tokens
      final response = await http.post(
        Uri.parse('$_baseUrl/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Firebase-AppCheck': appCheckToken,
        },
        body: json.encode(registrationData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        // If backend registration fails, delete the Firebase user
        await userCredential.user?.delete();
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Registration failed',
          status: response.statusCode,
        );
      }

      return AuthResponse(
        success: true,
        message: 'Registration successful',
        status: 200,
        data: {
          'token': token,
          'uid': uid,
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
} 