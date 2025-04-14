import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfig {
  static String decode(String encoded) {
    return utf8.decode(base64.decode(encoded));
  }
  
  static String encode(String jsonString) {
    return base64.encode(utf8.encode(jsonString));
  }
} 

Future<void> setupGoogleServices() async {
  try {
    // Ensure you have your google-services.json in the correct Android app directory
    if (Platform.isAndroid) {
      final String firebaseConfig = await rootBundle.loadString('assets/google-services.json');
      // If needed, add logic to copy it to the right location on the device.
    }
  } catch (e) {
    print("Error setting up Google Services: $e");
    rethrow;
  }
}