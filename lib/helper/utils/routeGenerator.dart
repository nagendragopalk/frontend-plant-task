import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_task/screens/HomeScreen.dart';
import 'package:plant_task/screens/authenticationScreen/loginAccount.dart';
import 'package:plant_task/screens/diagnosisHistoryScreen.dart';
import 'package:plant_task/screens/recommendationscreen.dart';
import 'package:plant_task/screens/splashScreen.dart';
import 'package:plant_task/screens/uploadDiagnosisScreen.dart';

const String splashScreen = 'splashScreen';
const String loginScreen = 'loginScreen';
const String mainHomeScreen = 'mainHomeScreen';
const String uploadDiagnosisScreen = 'uploadDiagnosisScreen';
const String recommendationscreen = "recommendationscreen";
const String diagnosisHistoryscreen = 'diagnosisHistoryscreen';

const String underMaintenanceScreen = 'underMaintenanceScreen';

String currentRoute = splashScreen;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentRoute = settings.name ?? "";

    switch (settings.name) {
      case splashScreen:
        return CupertinoPageRoute(builder: (_) => const SplashScreen());

      case loginScreen:
        return CupertinoPageRoute(
          builder: (_) => LoginAccount(from: settings.arguments as String?),
        );

      case mainHomeScreen:
        return CupertinoPageRoute(builder: (_) => const HomeScreen());
      case uploadDiagnosisScreen:
        return CupertinoPageRoute(
          builder: (_) => const UploadDiagnosisScreen(),
        );
      case recommendationscreen:
        return CupertinoPageRoute(builder: (_) => const Recommendationscreen());
      case diagnosisHistoryscreen:
        return CupertinoPageRoute(builder: (_) => const DiagnosisHistoryscreen());

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR')),
        );
      },
    );
  }
}
