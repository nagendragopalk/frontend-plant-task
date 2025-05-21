import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_task/helper/utils/generalMethods.dart';

Future logoutApi({
  required BuildContext context,
  required String refreshToken,
}) async {
  try {
    final dio = await GeneralMethods.sendApiRequest(context: context);

    final response = await dio.post(
      "/users/logout/",
      data: {"refresh": refreshToken},
    );

    return json.decode(response.toString());
  } catch (e) {
    rethrow;
  }
}
