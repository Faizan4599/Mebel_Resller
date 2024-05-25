class GetCategoriesDataModel {
  String? category_id;
  String? category_name;

  GetCategoriesDataModel({this.category_id, this.category_name});

  factory GetCategoriesDataModel.fromJson(Map<String, dynamic> json) {
    return GetCategoriesDataModel(
        category_id: json['category_id'], category_name: json['category_name']);
  }

  Map<String, dynamic> toJson() =>
      {'category_id': category_id, 'category_name': category_name};
}
