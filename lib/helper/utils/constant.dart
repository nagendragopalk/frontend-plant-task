import 'package:flutter/material.dart';
import 'package:plant_task/helper/utils/sessionManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NetworkStatus { online, offline }

enum ThemeList { systemDefault, light, dark }

class Constant {
  static String baseUrl = "http://192.168.31.159:8000/";
 


  static int minimumRequiredMobileNumberLength = 7;

  static int messageDisplayDuration = 3500; // resend otp timer
 
  static SharedPreferences? prefs = null;

 static List<String> themeList = ["System default", "Light", "Dark"];
  static GlobalKey<NavigatorState> navigatorKay = GlobalKey<NavigatorState>();

 

  static BorderRadius borderRadius2 = BorderRadius.circular(2);
  static BorderRadius borderRadius5 = BorderRadius.circular(5);
  static BorderRadius borderRadius7 = BorderRadius.circular(7);
  static BorderRadius borderRadius10 = BorderRadius.circular(10);
  static BorderRadius borderRadius13 = BorderRadius.circular(13);

  static late SessionManager session;
  

  static String getAssetsPath(int folder, String filename) {
    //0-image,1-svg,2-language,3-animation

    String path = "";
    switch (folder) {
      case 0:
        path = "assets/images/$filename";
        break;
      case 1:
        path = "assets/svg/$filename.svg";
        break;
      case 2:
        path = "assets/language/$filename.json";
        break;
      case 3:
        path = "assets/animation/$filename.json";
        break;
      case 4:
        path = "assets/$filename.json";
    }

    return path;
  }

  //Default padding and margin variables

  static double size2 = 2.00;
  static double size3 = 3.00;
  static double size5 = 5.00;
  static double size7 = 7.00;
  static double size8 = 8.00;
  static double size10 = 10.00;
  static double size12 = 12.00;
  static double size14 = 14.00;
  static double size15 = 15.00;
  static double size18 = 18.00;
  static double size20 = 20.00;
  static double size25 = 20.00;
  static double size30 = 30.00;
  static double size35 = 35.00;
  static double size40 = 40.00;
  static double size50 = 50.00;
  static double size60 = 60.00;
  static double size65 = 65.00;
  static double size70 = 70.00;
  static double size75 = 75.00;
  static double size80 = 80.00;



  
  static String noInternetConnection = "no_internet_connection";
  static String somethingWentWrong = "something_went_wrong";
}
