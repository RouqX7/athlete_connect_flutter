import 'dart:convert';

class FirebaseConfig {
  static String decode(String encoded) {
    return utf8.decode(base64.decode(encoded));
  }
  
  static String encode(String jsonString) {
    return base64.encode(utf8.encode(jsonString));
  }
} 