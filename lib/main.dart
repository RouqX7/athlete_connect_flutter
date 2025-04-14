import 'package:flutter/material.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_service.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up the SettingsController
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme
  await settingsController.loadSettings();

  // Run the app
  runApp(AthleteConnectApp(settingsController: settingsController));
}
