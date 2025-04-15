import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown error',
      status: json['status'] ?? 500,
      data: json['data'],
    );
  }
}

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:3300'; 
  final _prefs = SharedPreferences.getInstance();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  Future<String?> _getToken() async {
    final prefs = await _prefs;
    return prefs.getString('token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString('token', token);
  }

  Future<void> _clearToken() async {
    final prefs = await _prefs;
    await prefs.remove('token');
  }

  // Sign in with email and password
  Future<AuthResponse> signIn(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/login'),
      headers: _headers,
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);
    final authResponse = AuthResponse.fromJson(responseData);

    if (authResponse.success && authResponse.data?['token'] != null) {
      await _saveToken(authResponse.data!['token']);
    }

    return authResponse;
  } catch (e) {
    return AuthResponse(
      success: false,
      message: e.toString(),
      status: 500,
    );
  }
}

  // Register with email and password
  Future<AuthResponse> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/register'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      return AuthResponse.fromJson(responseData);
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
    await _clearToken();
  }

  // Get current user profile
  Future<AuthResponse> getCurrentProfile() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/auth/profile'), headers: _headers);
      final responseData = json.decode(response.body);
      return AuthResponse.fromJson(responseData);
    } catch (e) {
      print('Error getting profile: $e');
      return AuthResponse(
        success: false,
        message: e.toString(),
        status: 500,
      );
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null;
  }
}