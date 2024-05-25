// To parse this JSON data, do
//
//     final sampleDataModel = sampleDataModelFromJson(jsonString);

import 'dart:convert';

List<SampleDataModel> sampleDataModelFromJson(String str) =>
    List<SampleDataModel>.from(
        json.decode(str).map((x) => SampleDataModel.fromJson(x)));

String sampleDataModelToJson(List<SampleDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SampleDataModel {
  String id;
  String productId;
  String productImage;
  String productPrice;
  bool isChecked;

  SampleDataModel(
      {required this.id,
      required this.productId,
      required this.productImage,
      required this.productPrice,
      required this.isChecked});

  factory SampleDataModel.fromJson(Map<String, dynamic> json) =>
      SampleDataModel(
        id: json["id"],
        productId: json["productId"],
        productImage: json["productImage"],
        productPrice: json["productPrice"],
        isChecked: json["isChecked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "productImage": productImage,
        "productPrice": productPrice,
        "isChecked": isChecked,
      };
}
