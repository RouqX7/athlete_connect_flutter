import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart' as dotenv;

Future<void> main() async {
  try {
    // Load .env file
    final env = dotenv.DotEnv()..load();

    final encodedConfig = env['FIREBASE_CONFIG_ENCODED'];
    if (encodedConfig == null) {
      throw Exception('FIREBASE_CONFIG_ENCODED not found in .env file');
    }

    final decoded = utf8.decode(base64.decode(encodedConfig));

    final outputFile = File('android/app/google-services.json');
    await outputFile.writeAsString(decoded, flush: true);

    print('✅ google-services.json written successfully!');
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}
