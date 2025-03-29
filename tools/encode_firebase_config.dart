import 'dart:io';
import 'dart:convert';

void main() {
  final file = File('android/app/google-services.json');
  final contents = file.readAsStringSync();
  final encoded = base64.encode(utf8.encode(contents));
  print(encoded);
} 