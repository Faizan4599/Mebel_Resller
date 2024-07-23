class GetAllQuotesDataModel {
  String? quote_id;
  String? cust_name;
  String? cust_phone;
  String? quote_date;
  String? created_at;
  String? quote_price;
  GetAllQuotesDataModel(
      {required this.quote_id,
      required this.cust_name,
      required this.cust_phone,
      required this.quote_date,
      required this.created_at,
      required this.quote_price});

  factory GetAllQuotesDataModel.fromJson(Map<String, dynamic> json) {
    return GetAllQuotesDataModel(
        quote_id: json["quote_id"],
        cust_name: json["cust_name"],
        cust_phone: json["cust_phone"],
        quote_date: json["quote_date"],
        created_at: json["created_at"],
        quote_price: json["quote_price"]);
  }
  Map<String, dynamic> toJson() => {
        "quote_id": quote_id,
        "cust_name": cust_name,
        "cust_phone": cust_phone,
        "quote_date": quote_date,
        "created_at": created_at,
        "quote_price": quote_price
      };
}
