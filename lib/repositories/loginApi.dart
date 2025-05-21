import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plant_task/helper/utils/generalMethods.dart';

Future<Map<String, dynamic>> getLoginApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  try {
    final dio = await GeneralMethods.postInstance(
      context: context,
    );

    final response = await dio.post("/users/login/", data: params);

    final responseData = json.decode(response.toString());

   if (responseData.containsKey('detail')) {
      throw Exception(responseData['detail']);
    }

    return responseData;
  } catch (e) {
    if (e is DioException && e.response != null) {
      final errorData = e.response?.data;

      if (errorData != null && errorData['detail'] != null) {
       throw Exception(errorData['detail']);
      }
    }
    
    throw Exception(e);
  }
}

