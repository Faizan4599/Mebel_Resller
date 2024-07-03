class GetInsertQuoteDataModel {
  String? message;
  String? description;
  int? quote_id;
  GetInsertQuoteDataModel(
      {required this.message, this.description, required this.quote_id});
  factory GetInsertQuoteDataModel.fromJson(Map<String, dynamic> json) =>
      GetInsertQuoteDataModel(
          message: json["message"],
          description: json["description"],
          quote_id: json["quote_id"]);
  Map<String, dynamic> toJson() =>
      {"message": message, "description": description, "quote_id": quote_id};
}
