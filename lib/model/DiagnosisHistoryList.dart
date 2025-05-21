// To parse this JSON data, do
//
//     final diagnosisHistoryList = diagnosisHistoryListFromJson(jsonString);

import 'dart:convert';

DiagnosisHistoryList diagnosisHistoryListFromJson(String str) => DiagnosisHistoryList.fromJson(json.decode(str));

String diagnosisHistoryListToJson(DiagnosisHistoryList data) => json.encode(data.toJson());

class DiagnosisHistoryList {
    int? count;
    List<DiagnosisHistoryData>? results;

    DiagnosisHistoryList({
        this.count,
        this.results,
    });

    factory DiagnosisHistoryList.fromJson(Map<String, dynamic> json) => DiagnosisHistoryList(
        count: json["count"],
        results: List<DiagnosisHistoryData>.from(json["results"].map((x) => DiagnosisHistoryData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class DiagnosisHistoryData {
    int ?id;
    String?code;
    String? diseaseimage;
    Crop ?crop;
    PestRecommendation? pestRecommendation;
    String? createdon;

    DiagnosisHistoryData({
        this.id,
        this.code,
        this.diseaseimage,
        this.crop,
        this.pestRecommendation,
        this.createdon,
    });

    factory DiagnosisHistoryData.fromJson(Map<String, dynamic> json) => DiagnosisHistoryData(
        id: json["id"],
        code: json["code"],
        diseaseimage: json["diseaseimage"],
        crop: Crop.fromJson(json["crop"]),
        pestRecommendation: PestRecommendation.fromJson(json["pest_recommendation"]),
        createdon: json["createdon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "diseaseimage": diseaseimage,
        "crop": crop!.toJson(),
        "pest_recommendation": pestRecommendation!.toJson(),
        "createdon": createdon,
    };
}

class Crop {
    int? id;
    String? code;
    String? name;
    String ?cropimage;
    String ?description;
    String? createdon;

    Crop({
        this.id,
        this.code,
        this.name,
        this.cropimage,
        this.description,
        this.createdon,
    });

    factory Crop.fromJson(Map<String, dynamic> json) => Crop(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        cropimage: json["cropimage"],
        description: json["description"],
        createdon: json["createdon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "cropimage": cropimage,
        "description": description,
        "createdon": createdon,
    };
}

class PestRecommendation {
    int ?id;
    String? code;
    String? name;
    String? pestimage;
    Crop ?crop;
    String? severity;
    String? suggestedTreatment;
    String? createdon;

    PestRecommendation({
        this.id,
        this.code,
        this.name,
        this.pestimage,
        this.crop,
        this.severity,
        this.suggestedTreatment,
        this.createdon,
    });

    factory PestRecommendation.fromJson(Map<String, dynamic> json) => PestRecommendation(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        pestimage: json["pestimage"],
        crop: Crop.fromJson(json["crop"]),
        severity: json["severity"],
        suggestedTreatment: json["suggested_treatment"],
        createdon: json["createdon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "pestimage": pestimage,
        "crop": crop!.toJson(),
        "severity": severity,
        "suggested_treatment": suggestedTreatment,
        "createdon": createdon,
    };
}
