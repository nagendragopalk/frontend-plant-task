import 'package:flutter/material.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';
import 'package:plant_task/helper/utils/constant.dart';
import 'package:plant_task/helper/utils/routeGenerator.dart';
import 'package:plant_task/helper/utils/sessionManager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      startTime();
    });
  }

  void startTime() async {
    if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
     Navigator.pushReplacementNamed(context, mainHomeScreen);
    } else {
    Navigator.pushReplacementNamed(context, loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Plant Task",
                  style: TextStyle(
                    color: ColorsRes.appColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
