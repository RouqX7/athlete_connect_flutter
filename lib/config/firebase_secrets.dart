class FirebaseSecrets {
  static const String encodedConfig = 'your_base64_encoded_config';
  
  static String get decodedConfig => FirebaseConfig.decode(encodedConfig);
} 