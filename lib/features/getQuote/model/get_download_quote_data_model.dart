class GetDownloadQuoteDataModel {
  String? quote_id;
  String? cust_name;
  String? cust_phone;
  String? quote_date;
  String? created_at;
  String? quote_price;
  String? cust_address;
  String? tnc;
  String? is_gst_quote;
  List<QuoteItem>? quoteItems;
  GetDownloadQuoteDataModel({
    this.quote_id,
    this.cust_name,
    this.cust_phone,
    this.quote_date,
    this.created_at,
    this.quote_price,
    this.cust_address,
    this.tnc,
    this.is_gst_quote,
    this.quoteItems,
  });

  factory GetDownloadQuoteDataModel.fromJson(Map<String, dynamic> json) =>
      GetDownloadQuoteDataModel(
        quote_id: json["quote_id"],
        cust_name: json["cust_name"],
        cust_phone: json["cust_phone"],
        quote_date: json["quote_date"],
        created_at: json["created_at"],
        quote_price: json["quote_price"],
        cust_address: json["cust_address"],
        tnc: json["tnc"],
        is_gst_quote: json["is_gst_quote"],
        quoteItems: List<QuoteItem>.from(
            json["quoteItems"].map((x) => QuoteItem.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "quote_id": quote_id,
        "cust_name": cust_name,
        "cust_phone": cust_phone,
        "quote_date": quote_date,
        "created_at": created_at,
        "quote_price": quote_price,
        "cust_address": cust_address,
        "tnc": tnc,
        "is_gst_quote": is_gst_quote,
        "quoteItems": List<dynamic>.from(quoteItems ??
            [].map(
              (x) => x.toJson(),
            )),
      };
}

class QuoteItem {
  String? quote_id;
  String? product_id;
  String? product_name;
  String? folder_name;
  String? region_id;
  String? region_name;
  String? style_id;
  String? style_name;
  String? qty;
  String? price;
  String? product_url;

  QuoteItem(
      {this.quote_id,
      this.product_id,
      this.product_name,
      this.folder_name,
      this.region_id,
      this.region_name,
      this.style_id,
      this.style_name,
      this.qty,
      this.price,
      this.product_url});

  factory QuoteItem.fromJson(Map<String, dynamic> json) => QuoteItem(
      quote_id: json["quote_id"],
      product_id: json["product_id"],
      product_name: json["product_name"],
      folder_name: json["folder_name"],
      region_id: json["region_id"],
      region_name: json["region_name"],
      style_id: json["style_id"],
      style_name: json["style_name"],
      qty: json["qty"],
      price: json["price"],
      product_url: json["product_url"]);

  Map<String, dynamic> toJson() => {
        "quote_id": quote_id,
        "product_id": product_id,
        "product_name": product_name,
        "folder_name": folder_name,
        "region_id": region_id,
        "region_name": region_name,
        "style_id": style_id,
        "style_name": style_name,
        "qty": qty,
        "price": price,
        "product_url": product_url
      };
}
