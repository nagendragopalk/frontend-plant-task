import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:plant_task/helper/generalWidgets/customTextLabel.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';
import 'package:plant_task/helper/utils/constant.dart';
import 'package:plant_task/helper/utils/routeGenerator.dart';
import 'package:plant_task/repositories/logoutApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager extends ChangeNotifier {
  static String isUserLogin = "isUserLogin";
  static String keyAccessToken = "accessToken";
  static String keyRefreshToken = "refreshToken";
  static String keyUserImage = "keyUserImage";
  static String keyUserName = "username";
  static String keyUserFullName = "userFullName";
  static String keyEmail = "email";
  static String appThemeName = "appThemeName";
  static String isDarkTheme = "isDarkTheme";
  

  late SharedPreferences prefs;

  SessionManager({required this.prefs});

  String getData(String id) {
    return prefs.getString(id) ?? "";
  }

  void setData(String id, String val, bool isRefresh) {
    prefs.setString(id, val);
    if (isRefresh) {
      notifyListeners();
    }
  }



  Future setUserData({
    required BuildContext context,
    required String username,
    required String email,
    required String fullName,
    required String accessToken,
    required String refreshToken,
  }) async {
    prefs.setString(keyAccessToken, accessToken);
    prefs.setString(keyRefreshToken, refreshToken);

    setData(keyUserName, username, true);
    setData(keyUserFullName, fullName, true);
    setData(keyEmail, email, true);

    setBoolData(isUserLogin, true, true);

    notifyListeners();
  }

  void setDoubleData(String key, double value) {
    prefs.setDouble(key, value);
    notifyListeners();
  }

  double getDoubleData(String key) {
    return prefs.getDouble(key) ?? 0.0;
  }

  bool getBoolData(String key) {
    return prefs.getBool(key) ?? false;
  }

  void setBoolData(String key, bool value, bool isRefresh) {
    prefs.setBool(key, value);
    if (isRefresh) notifyListeners();
  }

  int getIntData(String key) {
    return prefs.getInt(key) ?? 0;
  }

  void setIntData(String key, int value) {
    prefs.setInt(key, value);
    notifyListeners();
  }

  bool isUserLoggedIn() {
    return getBoolData(isUserLogin);
  }

  void logoutUser(BuildContext buildContext) {
    showDialog<String>(
      context: buildContext,
      builder:
          (BuildContext context) => AlertDialog(
            backgroundColor: Theme.of(buildContext).cardColor,
            surfaceTintColor: Colors.transparent,
            title: const CustomTextLabel(text: "Logout!", softWrap: true),
            content: const CustomTextLabel(
              text: "Are you sure?\nYou want to logout?",
              softWrap: true,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: CustomTextLabel(
                  text: "Cancel",
                  softWrap: true,
                  style: TextStyle(color: ColorsRes.subTitleMainTextColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  logoutApi(
                    context: context,
                    refreshToken: getData(keyRefreshToken),
                  );
                  String themeName = getData(appThemeName);

                  bool isDark = false;
                  if (themeName == Constant.themeList[2]) {
                    isDark = true;
                  } else if (themeName == Constant.themeList[1]) {
                    isDark = false;
                  } else if (themeName == "" ||
                      themeName == Constant.themeList[0]) {
                    var brightness =
                        PlatformDispatcher.instance.platformBrightness;
                    isDark = brightness == Brightness.dark;

                    if (themeName == "") {
                      setData(appThemeName, Constant.themeList[0], false);
                    }
                  }
                  prefs.clear();
                  setBoolData(isUserLogin, false, false);
                  setData(appThemeName, themeName, false);

                  Navigator.of(buildContext).pushNamedAndRemoveUntil(
                    loginScreen,
                    (Route<dynamic> route) => false,
                  );
                },
                child: CustomTextLabel(
                  text: "Ok",
                  softWrap: true,
                  style: TextStyle(color: ColorsRes.appColor),
                ),
              ),
            ],
          ),
    );
  }
}
