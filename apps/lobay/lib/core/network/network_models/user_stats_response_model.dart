// To parse this JSON data, do
//
//     final getUserActivityResponseModel = getUserActivityResponseModelFromJson(jsonString);

import 'dart:convert';

GetUserActivityResponseModel getUserActivityResponseModelFromJson(String str) => GetUserActivityResponseModel.fromJson(json.decode(str));

String getUserActivityResponseModelToJson(GetUserActivityResponseModel data) => json.encode(data.toJson());

class GetUserActivityResponseModel {
    bool? success;
    Data? data;

    GetUserActivityResponseModel({
        this.success,
        this.data,
    });

    factory GetUserActivityResponseModel.fromJson(Map<String, dynamic> json) => GetUserActivityResponseModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class Data {
    BasicInfo? basicInfo;
    int? opponents;
    int? totalActivities;
    ActivityDetails? activityDetails;

    Data({
        this.basicInfo,
        this.opponents,
        this.totalActivities,
        this.activityDetails,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        basicInfo: json["basicInfo"] == null ? null : BasicInfo.fromJson(json["basicInfo"]),
        opponents: json["opponents"],
        totalActivities: json["totalActivities"],
        activityDetails: json["activityDetails"] == null ? null : ActivityDetails.fromJson(json["activityDetails"]),
    );

    Map<String, dynamic> toJson() => {
        "basicInfo": basicInfo?.toJson(),
        "opponents": opponents,
        "totalActivities": totalActivities,
        "activityDetails": activityDetails?.toJson(),
    };
}

class ActivityDetails {
    String? activity;
    String? playerLevel;

    ActivityDetails({
        this.activity,
        this.playerLevel,
    });

    factory ActivityDetails.fromJson(Map<String, dynamic> json) => ActivityDetails(
        activity: json["activity"],
        playerLevel: json["playerLevel"],
    );

    Map<String, dynamic> toJson() => {
        "activity": activity,
        "playerLevel": playerLevel,
    };
}

class BasicInfo {
    String? name;
    String? profileImage;
    Location? location;

    BasicInfo({
        this.name,
        this.profileImage,
        this.location,
    });

    factory BasicInfo.fromJson(Map<String, dynamic> json) => BasicInfo(
        name: json["name"],
        profileImage: json["profileImage"],
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "profileImage": profileImage,
        "location": location?.toJson(),
    };
}

class Location {
    String? placeName;
    String? countryName;
    String? state;

    Location({
        this.placeName,
        this.countryName,
        this.state,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        placeName: json["placeName"],
        countryName: json["countryName"],
        state: json["state"],
    );

    Map<String, dynamic> toJson() => {
        "placeName": placeName,
        "countryName": countryName,
        "state": state,
    };
}