class GetStylesDataModel {
  String? style_id;
  String? style_name;
  GetStylesDataModel({this.style_id, this.style_name});

  factory GetStylesDataModel.fromJson(Map<String, dynamic> json) {
    return GetStylesDataModel(
        style_id: json["style_id"] ?? "", style_name: json["style_name"] ?? "");
  }

  Map<String, dynamic> toJson() =>
      {"style_id": style_id, "style_name": style_name};
}
