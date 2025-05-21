import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plant_task/helper/utils/generalMethods.dart';

Future getRecommendationDataApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  try {
    final dio = await GeneralMethods.sendApiRequest(
      context: context,
    );
   

    final response = await dio.get(
        "/CropDiagnosis/pestdiseaseupload/${params["pestDiseaseId"]}",
        queryParameters: {});

    return json.decode(response.toString());
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> pestDiseaseUploadApi({
  required BuildContext context,
  required Map<String, dynamic> params,
}) async {
  FormData formData = FormData();

  if (params["diseaseimage"] != null) {
    XFile file = params["diseaseimage"];
    formData = FormData.fromMap({
      ...params,
      "diseaseimage":
          await MultipartFile.fromFile(file.path, filename: file.name),
    });
  } else {
    formData = FormData.fromMap({...params});
  }

  try {
    final dio = await GeneralMethods.sendApiRequest(
      context: context,
    );

    final response =
        await dio.post("/CropDiagnosis/pestdiseaseupload", data: formData);

    return json.decode(response.toString());
  } catch (e) {
    // debugPrint("Error>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: ${e.toString()}");
    rethrow;
  }
}



Future getDiagnosisHistoryListDataApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  try {
    final dio = await GeneralMethods.sendApiRequest(
      context: context,
    );
    
    final response =
        await dio.get("/CropDiagnosis/pestdiseaseupload", queryParameters: params);

    return json.decode(response.toString());
  } catch (e) {
    rethrow;
  }
}