class ProductDataModel {
  String? message;
  String? description;

  ProductDataModel({this.message, this.description});
  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
        message: json["message"] ?? "", description: json["description"] ?? "");
  }
  Map<String, dynamic> toJson() => {
        "message": message ?? "",
        "description": description ?? "",
      };
}
