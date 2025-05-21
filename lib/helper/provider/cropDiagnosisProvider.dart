import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plant_task/helper/utils/routeGenerator.dart';
import 'package:plant_task/model/CropCategoryList.dart';
import 'package:plant_task/model/DiagnosisHistoryList.dart';
import 'package:plant_task/model/PestRecommendationData.dart';
import 'package:plant_task/repositories/homeScreenApi.dart';
import 'package:plant_task/repositories/recommendationScreenApi.dart';

enum DiagnosisScreenState { initial, loading, loaded, error }

class CropDiagnosisProvider extends ChangeNotifier {
  DiagnosisScreenState diagnosisScreenState = DiagnosisScreenState.initial;
  late CropCategoryList cropList;
  late DiagnosisHistoryList diagnosisHistoryList;
  String message = '';
  late PestRecommendationData pestData;

  Future getCropListApiProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    diagnosisScreenState = DiagnosisScreenState.loading;
    notifyListeners();
    cropList = CropCategoryList();
    try {
      Map<String, dynamic> response = await getCropListDataApi(
        context: context,
        params: params,
      );
      cropList = CropCategoryList.fromJson(response);
      diagnosisScreenState = DiagnosisScreenState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      diagnosisScreenState = DiagnosisScreenState.error;
      notifyListeners();
    }
  }

  Future getDiagnosisHistoryListApiProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    diagnosisScreenState = DiagnosisScreenState.loading;
    notifyListeners();
    diagnosisHistoryList = DiagnosisHistoryList();
    try {
      Map<String, dynamic> response = await getDiagnosisHistoryListDataApi(
        context: context,
        params: params,
      );
      diagnosisHistoryList = DiagnosisHistoryList.fromJson(response);
      print("Diagnosis History List: ${diagnosisHistoryList.toJson()}");
      diagnosisScreenState = DiagnosisScreenState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      diagnosisScreenState = DiagnosisScreenState.error;
      notifyListeners();
    }
  }

  Future<void> getPestDiseaseUploadProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    diagnosisScreenState = DiagnosisScreenState.loading;
    pestData = PestRecommendationData();
    // pestDiseaseUploadData = PestDiseaseUploadModel();
    notifyListeners();

    try {
      Map<String, dynamic> response = await pestDiseaseUploadApi(
        context: context,
        params: params,
      );

      pestData = PestRecommendationData.fromJson(response);
      notifyListeners();
      diagnosisScreenState = DiagnosisScreenState.loaded;

      if (params["crop_id"] == pestData.crop!.id) {
        Navigator.pushNamed(context, recommendationscreen);
      } else {
        diagnosisScreenState = DiagnosisScreenState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>> $message");

      diagnosisScreenState = DiagnosisScreenState.error;
      notifyListeners();
    }
  }
  Future<void> getDiagnosisDataProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    diagnosisScreenState = DiagnosisScreenState.loading;
    notifyListeners();
    try {
       pestData = PestRecommendationData();
      Map<String, dynamic> response = await getRecommendationDataApi(
        context: context,
        params: params,
      );
       pestData = PestRecommendationData.fromJson(response);
      diagnosisScreenState = DiagnosisScreenState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      diagnosisScreenState = DiagnosisScreenState.error;
      notifyListeners();
    }
  }
}
