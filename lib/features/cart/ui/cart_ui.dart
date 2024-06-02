// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:reseller_app/features/landscreen/model/get_product_data_model.dart';

class CartUi extends StatelessWidget {
  List<GetProductDataModel> cartItems;
  CartUi({
    Key? key,
    required this.cartItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
