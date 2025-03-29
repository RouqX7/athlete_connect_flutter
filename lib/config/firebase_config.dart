import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FirebaseConfig {
  static String get projectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get storageBucket => dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';
  static String get messagingSenderId => dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get appId => dotenv.env['FIREBASE_APP_ID'] ?? '';
  static String get apiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get databaseUrl => dotenv.env['FIREBASE_DATABASE_URL'] ?? '';

  static String? getDecodedConfig() {
    final encoded = dotenv.env['FIREBASE_CONFIG_ENCODED'];
    if (encoded == null) return null;
    return utf8.decode(base64.decode(encoded));
  }

  static Future<void> setupFirebaseConfig() async {
    final encoded = dotenv.env['FIREBASE_CONFIG_ENCODED'];
    if (encoded == null) return;

    final decoded = utf8.decode(base64.decode(encoded));
    final tempDir = await getTemporaryDirectory();
    final configFile = File('${tempDir.path}/google-services.json');
    
    // Write the decoded config to the correct location
    final androidAppDir = Directory('android/app');
    if (!androidAppDir.existsSync()) {
      androidAppDir.createSync(recursive: true);
    }
    
    final googleServicesFile = File('android/app/google-services.json');
    await googleServicesFile.writeAsString(decoded);
  }
} 