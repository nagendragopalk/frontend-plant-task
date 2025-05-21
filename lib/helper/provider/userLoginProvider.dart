import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plant_task/helper/utils/constant.dart';
import 'package:plant_task/helper/utils/generalMethods.dart';
import 'package:plant_task/helper/utils/sessionManager.dart';
import 'package:plant_task/model/loginProfileData.dart';
import 'package:plant_task/repositories/loginApi.dart';

enum LoginProfileState { initial, loading, loaded, error }

class UserLoginProvider extends ChangeNotifier {
  LoginProfileState userLoginState = LoginProfileState.initial;
  String message = '';
  getInitialData({required BuildContext context}) {
    userLoginState = LoginProfileState.initial;
    notifyListeners();
  }

  Future loginApi({
    required BuildContext context,
    required Map<String, String> params,
  }) async {
    try {
      // Set the state to loading and notify listeners
      userLoginState = LoginProfileState.loading;
      notifyListeners();

      // Declare the login profile data variable
      LoginProfileData? loginProfile;

      // Call the getLoginApi method
      final mainData = await getLoginApi(context: context, params: params);

      // Check if the response contains valid data
      loginProfile = LoginProfileData.fromJson(mainData);

      // If loginProfile is not null, save user data in session
      if (loginProfile != null) {
        await setUserDataInSession(loginProfile, context);
        userLoginState = LoginProfileState.loaded;
      } else {
        // If loginProfile is null, show a warning message to the user
        GeneralMethods.showMessage(
          context,
          mainData["message"] ?? "Something went wrong.",
          MessageType.warning,
        );
        userLoginState = LoginProfileState.error;
      }

      notifyListeners();
      return loginProfile; // Return profile data or "0"
    } catch (e) {
      // Catch and handle exceptions, updating the state to error
      userLoginState = LoginProfileState.error;
      notifyListeners();

      // Show the error message to the user
      GeneralMethods.showMessage(context, e.toString(), MessageType.error);

      return "0"; // Return "0" in case of an error
    }
  }

  Future setUserDataInSession(
    LoginProfileData loginProfile,
    BuildContext context,
  ) async {
    Constant.session.setBoolData(SessionManager.isUserLogin, true, false);

    Constant.session.setUserData(
      context: context,
      username: loginProfile.username ?? '',
      email: loginProfile.email ?? '',
      fullName: loginProfile.fullName ?? '',
      accessToken: loginProfile.tokens?.access ?? '',
      refreshToken: loginProfile.tokens?.refresh ?? '',
    );

    userLoginState = LoginProfileState.loaded;
    notifyListeners();
  }

}
