class GetTNCDataModel {
  String? tnc;

  GetTNCDataModel({this.tnc});

  factory GetTNCDataModel.fromJson(Map<String, dynamic> json) =>
      GetTNCDataModel(tnc: json["tnc"]);

  Map<String, dynamic> toJson() => {"tnc": tnc ?? ""};
}
