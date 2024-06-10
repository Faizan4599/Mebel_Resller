class CartCommonDataModel {
  CartCommonDataModel({this.message, this.description});
  String? message;
  String? description;
  factory CartCommonDataModel.fromJson(Map<String, dynamic> json) =>
      CartCommonDataModel(
          message: json['message'], description: json['description']);
}
