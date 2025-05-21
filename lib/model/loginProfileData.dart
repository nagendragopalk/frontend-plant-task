// To parse this JSON data, do
//
//     final loginProfileData = loginProfileDataFromJson(jsonString);

import 'dart:convert';

LoginProfileData loginProfileDataFromJson(String str) => LoginProfileData.fromJson(json.decode(str));

String loginProfileDataToJson(LoginProfileData data) => json.encode(data.toJson());

class LoginProfileData {
    String ?email;
    String? username;
    Tokens? tokens;
    String? fullName;

    LoginProfileData({
        this.email,
        this.username,
        this.tokens,
        this.fullName,
    });

    factory LoginProfileData.fromJson(Map<String, dynamic> json) => LoginProfileData(
        email: json["email"],
        username: json["username"],
        tokens: Tokens.fromJson(json["tokens"]),
        fullName: json["full_name"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "tokens": tokens!.toJson(),
        "full_name": fullName,
    };
}

class Tokens {
    String ?refresh;
    String ?access;

    Tokens({
        this.refresh,
        this.access,
    });

    factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
        refresh: json["refresh"],
        access: json["access"],
    );

    Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
    };
}
