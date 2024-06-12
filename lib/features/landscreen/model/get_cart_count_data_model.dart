class GetCartCountDataModel {
  String? cart_count;
  GetCartCountDataModel({required this.cart_count});

  factory GetCartCountDataModel.fromJson(Map<String, dynamic> json) {
    return GetCartCountDataModel(
      cart_count: json["cart_count"],
    );
  }
}
