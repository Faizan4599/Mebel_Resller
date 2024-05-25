class LoginCommonDataModel {
  String? id;
  String? name;
  bool? isLogin;
  LoginCommonDataModel({this.id, this.name, required this.isLogin});

  factory LoginCommonDataModel.fromJson(Map<String, dynamic> json) {
    return LoginCommonDataModel(
        id: json['id'], name: json['name'], isLogin: null);
  }
  Map<String, dynamic> toJson() => {'id': id, 'name': name, "isLogin": isLogin};
}
