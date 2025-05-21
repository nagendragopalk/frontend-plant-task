import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_task/helper/utils/generalMethods.dart';

Future getCropListDataApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  try {
    final dio = await GeneralMethods.sendApiRequest(
      context: context,
    );
    
    final response =
        await dio.get("/CropDiagnosis/crop/", queryParameters: params);

    return json.decode(response.toString());
  } catch (e) {
    rethrow;
  }
}
