// To parse this JSON data, do
//
//     final cropCategoryList = cropCategoryListFromJson(jsonString);

import 'dart:convert';

CropCategoryList cropCategoryListFromJson(String str) => CropCategoryList.fromJson(json.decode(str));

String cropCategoryListToJson(CropCategoryList data) => json.encode(data.toJson());

class CropCategoryList {
    int? count;
    List<CropCategoryItem>? results;

    CropCategoryList({
        this.count,
        this.results,
    });

    factory CropCategoryList.fromJson(Map<String, dynamic> json) => CropCategoryList(
        count: json["count"],
        results: List<CropCategoryItem>.from(json["results"].map((x) => CropCategoryItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class CropCategoryItem {
    int? id;
    String? code;
    String? name;
    String? cropimage;
    String ?description;
    String? createdon;

    CropCategoryItem({
        this.id,
        this.code,
        this.name,
        this.cropimage,
        this.description,
        this.createdon,
    });

    factory CropCategoryItem.fromJson(Map<String, dynamic> json) => CropCategoryItem(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        cropimage: json["cropimage"],
        description: json["description"],
        createdon:json["createdon"],
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
