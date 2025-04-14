import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';


class FirebaseConfig {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static Map<String, String> getFirebaseOptions() {
    return {
      'apiKey': dotenv.env['FIREBASE_API_KEY'] ?? '',
      'appId': dotenv.env['FIREBASE_APP_ID'] ?? '',
      'messagingSenderId': dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      'projectId': dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
      'storageBucket': dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
      'databaseURL': dotenv.env['FIREBASE_DATABASE_URL'] ?? '',
    };
  }

  static Future<String?> getDecodedConfig() async {
    try {
      final encoded = dotenv.env['FIREBASE_CONFIG_ENCODED'];
      if (encoded == null) return null;
      
      final decoded = utf8.decode(base64.decode(encoded));
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/google-services.json');
      await file.writeAsString(decoded);
      
      return file.path;
    } catch (e) {
      print('Error decoding config: $e');
      return null;
    }
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