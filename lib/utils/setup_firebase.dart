import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> setupGoogleServices() async {
  try {
    // Load .env file
    await dotenv.load();
    
    // Get the encoded string from .env
    final encodedConfig = dotenv.env['FIREBASE_CONFIG_ENCODED'];
    if (encodedConfig == null) {
      throw Exception('FIREBASE_CONFIG_ENCODED not found in .env file');
    }

    // Decode the base64 string
    final decodedConfig = utf8.decode(base64.decode(encodedConfig));
    
    // Verify JSON structure
    final jsonConfig = jsonDecode(decodedConfig);
    if (!jsonConfig.containsKey('project_info')) {
      throw Exception('Invalid google-services.json format: missing project_info');
    }
    
    // Write to google-services.json
    final file = File('android/app/google-services.json');
    await file.writeAsString(decodedConfig, flush: true);
    
    print('Successfully created google-services.json with content:');
    print(decodedConfig);  // This will help us debug the content
  } catch (e) {
    print('Error setting up Firebase: $e');
    rethrow;
  }
}
