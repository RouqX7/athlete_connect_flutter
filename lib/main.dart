import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import './services/app_check_service.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import './config/firebase_config.dart';
import 'screens/profile_screen.dart';
import './utils/setup_firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // First, setup the google-services.json file
  await setupGoogleServices();
  
  // Initialize environment variables
  await FirebaseConfig.initialize();
  
  // Initialize Firebase
  final options = FirebaseConfig.getFirebaseOptions();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: options['apiKey']!,
      appId: options['appId']!,
      messagingSenderId: options['messagingSenderId']!,
      projectId: options['projectId']!,
      storageBucket: options['storageBucket']!,
      databaseURL: options['databaseURL'],
    ),
  );

  
  // Initialize Firebase App Check with Play Integrity
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  
  // Pre-warm the App Check token
  await AppCheckService().getValidToken();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athlete Connect',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile': (context) => ProfileScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
