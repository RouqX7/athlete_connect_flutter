import 'package:flutter/material.dart';
import 'package:athlete_connect_flutter/src/pages/auth/login_screen.dart';
import 'package:athlete_connect_flutter/src/pages/auth/register_screen.dart';
import 'package:athlete_connect_flutter/src/pages/auth/profile_screen.dart';
import 'package:athlete_connect_flutter/src/pages/home_screen.dart';
import 'routes.dart'

class RouteGenerator {
    static Route<dynamic> generateRoute(RouteSettings routeSettings, [SettingsController? settingsController]){
        return MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context){
                switch (routeSettings.name){
                    case Routes.LoginRoute:
                    return const Scaffold(body: LoginScreen());
                    case Routes.RegisterRoute:
                    return const Scaffold(body: RegisterScreen());
                    case Routes.ProfileRoute:
                    return const Scaffold(body: ProfileScreen());
                    case Routes.HomeRoute:
                    return const Scaffold(body: HomeScreen());
                    default:
                    return const Scaffold(body: LoginScreen());

                    default:
                    return _errorRoute();
                }
            },
        );
    }

     static Widget _errorRoute() {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
  }
}