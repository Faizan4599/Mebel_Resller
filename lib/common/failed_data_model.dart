class FailedCommonDataModel {
  FailedCommonDataModel({this.message, this.description});
  String? message;
  String? description;
  factory FailedCommonDataModel.fromJson(Map<String, dynamic> json) =>
      FailedCommonDataModel(
          message: json['Message'], description: json['Description']);
}
