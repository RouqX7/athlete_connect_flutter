import 'package:firebase_app_check/firebase_app_check.dart';

class AppCheckService {
  static final AppCheckService _instance = AppCheckService._internal();
  factory AppCheckService() => _instance;
  AppCheckService._internal();

  final FirebaseAppCheck _appCheck = FirebaseAppCheck.instance;
  String? _cachedToken;

  Future<String?> getValidToken() async {
    try {
      // Try to get a token, if cached token exists
      _cachedToken = await _appCheck.getToken();

      // If no token or expired, force refresh
      if (_cachedToken == null) {
        _cachedToken = await _appCheck.getToken(true); // Force refresh
      }

      print('App Check Token obtained successfully');
      return _cachedToken;
    } catch (e) {
      print('Error getting App Check token: $e');
      return null;
    }
  }
} 