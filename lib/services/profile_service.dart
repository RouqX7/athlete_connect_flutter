import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ProfileService {
  final String _baseUrl = 'http://10.0.2.2:3300'; 

Future<Map<String, dynamic>?> getCurrentProfile() async {
    print('[ProfileService] getCurrentProfile() called');
    try {
      final uid = AuthService.instance.currentUserId;
      print('[ProfileService] Using UID: ' + (uid ?? 'null'));
      if (uid == null) return null;
      final url = '$_baseUrl/api/v1/user/?uid=$uid';
      print('[ProfileService] GET URL: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode != 200) return null;
      print('[ProfileService] HTTP status: ${response.statusCode}');
      print('[ProfileService] HTTP response body: ${response.body}');
      if (response.body == null || response.body.isEmpty) {
  print('[ProfileService] Response body is null or empty!');
  return null;
}
      try {
  final data = json.decode(response.body);
  return data['data'] ?? data;
} catch (e) {
  print('[ProfileService] Error decoding response: $e');
  print('[ProfileService] Offending response: ${response.body}');
  return null;
}
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    try {
      final uid = AuthService.instance.currentUserId;
      if (uid == null) return false;

      final response = await http.put(
        Uri.parse('$_baseUrl/api/v1/user/?uid=$uid'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updates),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
}