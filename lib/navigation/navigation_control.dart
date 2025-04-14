import 'package:flutter/material.dart';


class NavigationControl {
  Widget? nextPage = Container();
  String? path = "/";
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigationControl({this.nextPage, this.path});

  navTo(BuildContext context) {
    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => nextPage!,
        ));
  }

  navToPath(BuildContext context,
      {String? navPath, Map<String, dynamic>? queryParams}) async {
    navPath ??= path;
    //print(queryParams);
    //print( Playlist.fromJson( queryParams!));
   return Navigator.pushNamed(context, navPath ?? "/", arguments: queryParams);

    //return navigatorKey.currentState!.pushNamed(navPath??path);
  }

  returnTo(BuildContext context, {Object? data}) {
    Navigator.pop(context, data);
  }

  scaleTo(BuildContext context) {
    Navigator.push(context, ScaleNav(nextPage: nextPage));
  }

  fadeToPath(BuildContext context, {navPath}) {
    navigatorKey.currentState!.pushNamed(navPath ?? path);
  }

  void replaceWith(BuildContext context) {
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => nextPage!,
        ));
  }

   replacePath(BuildContext context,
      {String? navPath, Map<String, dynamic>? queryParams}) async{
          navPath ??= path;
    if (navigatorKey.currentState != null) {
      path = Uri(path: path, queryParameters: queryParams).toString();
     return  navigatorKey.currentState!
          .pushNamedAndRemoveUntil(navPath??"/", (Route<dynamic> route) => false);
    } else {
      return Navigator.pushReplacementNamed(
          context, navPath ?? "/",arguments: queryParams);
    }
  }
}

class ScaleNav extends PageRouteBuilder {
  final Widget? nextPage;
  ScaleNav({this.nextPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              nextPage!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );
}

class FadeRoute extends PageRouteBuilder {
  final Widget? child;
  final String routeName;
  FadeRoute({this.child, this.routeName = "/"})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastLinearToSlowEaseIn,
              ),
            ),
            child: child,
          ),
        );
}

class SlideRoute extends PageRouteBuilder {
  final Widget? child;
  final String routeName;
  SlideRoute({this.child, this.routeName = "/"})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: Offset(200, 0),
              end: Offset(0, 0),
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastLinearToSlowEaseIn,
              ),
            ),
            child: child,
          ),
        );
}
