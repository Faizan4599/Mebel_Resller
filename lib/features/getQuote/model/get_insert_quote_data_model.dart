class GetInsertQuoteDataModel {
  String? message;
  String? description;
  GetInsertQuoteDataModel({required this.message, this.description});
  factory GetInsertQuoteDataModel.fromJson(Map<String, dynamic> json) =>
      GetInsertQuoteDataModel(
          message: json["message"], description: json["description"]);
  Map<String, dynamic> toJson() =>
      {"message": message, "description": description};
}
