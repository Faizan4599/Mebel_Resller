class GetSubCategories2DataModel {
  String subcategory2_id;
  String subcategory2_name;
  GetSubCategories2DataModel(
      {required this.subcategory2_id, required this.subcategory2_name});

  factory GetSubCategories2DataModel.fromJson(Map<String, dynamic> json) {
    return GetSubCategories2DataModel(
        subcategory2_id: json['subcategory2_id'],
        subcategory2_name: json['subcategory2_name']);
  }
}
