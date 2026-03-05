import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/dashboard_home_screen/dashboard_home_screen.dart';
import '../presentation/login_authentication_screen/login_authentication_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String dashboardHome = '/dashboard-home-screen';
  static const String loginAuthentication = '/login-authentication-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    dashboardHome: (context) => const DashboardHomeScreen(),
    loginAuthentication: (context) => const LoginAuthenticationScreen(),
    // TODO: Add your other routes here
  };
}
