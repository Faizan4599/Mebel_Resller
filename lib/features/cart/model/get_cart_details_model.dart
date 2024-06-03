class GetCartDetailsDataModel {
  String? product_id;
  String? name;
  String? price;
  String? description;
  String? folder_name;
  String? subcategory2_id;
  String? subcategory2;
  String? subcategory1_id;
  String? subcategory1;
  String? category_id;
  String? category;
  String? region_id;
  String? region;
  String? cart_qty;
  String? updated_at;
  String? product_url;

  GetCartDetailsDataModel({
    this.product_id,
    this.name,
    this.price,
    this.description,
    this.folder_name,
    this.subcategory2_id,
    this.subcategory2,
    this.subcategory1_id,
    this.subcategory1,
    this.category_id,
    this.category,
    this.region_id,
    this.region,
    this.cart_qty,
    this.updated_at,
    this.product_url,
  });

  factory GetCartDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return GetCartDetailsDataModel(
      product_id: json['product_id'] ?? "",
      name: json['name'] ?? "",
      price: json['price'] ?? "",
      description: json['description'] ?? "",
      folder_name: json['folder_name'] ?? "",
      subcategory2_id: json['subcategory2_id'] ?? "",
      subcategory2: json['subcategory2'] ?? "",
      subcategory1_id: json['subcategory1_id'] ?? "",
      subcategory1: json['subcategory1'] ?? "",
      category_id: json['category_id'] ?? "",
      category: json['category'] ?? "",
      region_id: json['region_id'] ?? "",
      region: json['region'] ?? "",
      cart_qty: json['cart_qty'] ?? "",
      updated_at: json['updated_at'] ?? "",
      product_url: json['product_url'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "product_id": product_id ?? "",
        "name": name ?? "",
        "price": price ?? "",
        "description": description ?? "",
        "folder_name": folder_name ?? "",
        "subcategory2_id": subcategory2_id ?? "",
        "subcategory2": subcategory2 ?? "",
        "subcategory1_id": subcategory1_id ?? "",
        "subcategory1": subcategory1 ?? "",
        "category_id": category_id ?? "",
        "category": category ?? "",
        "region_id": region_id ?? "",
        "region": region ?? "",
        "cart_qty": cart_qty ?? "",
        "updated_at": updated_at ?? "",
        "product_url": product_url ?? "",
      };
}

      // "product_id": "2056";
      //           "name": "Test P1";
      //           "price": "6200";
      //           "description": "Test P1";
      //           "folder_name": "test-p1";
      //           "subcategory2_id": "1";
      //           "subcategory2": "Wingback Chairs";
      //           "subcategory1_id": "2";
      //           "subcategory1": "SEATING";
      //           "category_id": "1";
      //           "category": "Sofas";
      //           "region_id": "1";
      //           "region": "Egypt";
      //           "cart_qty": "1";
      //           "updated_at": "2024-02-17 14:47:00";
      //           "created_at": "2024-01-21 09:37:21";
      //           "product_url": "https://test-furniture.shop/portal/assets/admin/products/test-p1_2056/test_img_1.png"