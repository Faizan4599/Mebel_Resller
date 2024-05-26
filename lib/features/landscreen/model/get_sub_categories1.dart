class GetSubCategories1DataModel {
  String subcategory1_id;
  String subcategory1_name;

  GetSubCategories1DataModel(
      {required this.subcategory1_id, required this.subcategory1_name});

  factory GetSubCategories1DataModel.fromJson(Map<String, dynamic> json) {
    return GetSubCategories1DataModel(
        subcategory1_id: json['subcategory1_id'],
        subcategory1_name: json['subcategory1_name']);
  }
}
