class OuterReponse {
  String? status;
  dynamic data;

  OuterReponse({required this.data, required this.status});

  factory OuterReponse.fromJson(Map<String, dynamic> json) {
    dynamic data;
    if (json['Data'] is List) {
      data = json['Data'];
    } else if (json['Data'] is Map) {
      data = json['Data'];
    }
    return OuterReponse(data: data, status: json['Status'] ?? '');
  }
}
