class GetRegionsDataModel {
  String region_id;
  String region_name;

  GetRegionsDataModel({required this.region_id, required this.region_name});

  factory GetRegionsDataModel.fromJson(Map<String, dynamic> json) {
    return GetRegionsDataModel(
        region_id: json['region_id'], region_name: json['region_name']);
  }
  Map<String, dynamic> toJson() =>
      {'region_id': region_id, 'region_name': region_name};
}
