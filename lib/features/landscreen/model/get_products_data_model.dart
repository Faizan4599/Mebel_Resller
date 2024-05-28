class GetProductsDataModel {
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
  String? created_at;
  String? product_url;

  GetProductsDataModel(
      {this.product_id,
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
      this.created_at,
      this.product_url});

  factory GetProductsDataModel.fromJson(Map<String, dynamic> json) {
    return GetProductsDataModel(
        product_id: json['product_id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        folder_name: json['folder_name'],
        subcategory2_id: json['subcategory2_id'],
        subcategory2: json['subcategory2'],
        subcategory1_id: json['subcategory1_id'],
        subcategory1: json['subcategory1'],
        category_id: json['category_id'],
        category: json['category'],
        region_id: json['region_id'],
        region: json['region'],
        cart_qty: json['cart_qty'],
        updated_at: json['updated_at'],
        created_at: json['created_at'],
        product_url: json['product_url']);
  }
}
