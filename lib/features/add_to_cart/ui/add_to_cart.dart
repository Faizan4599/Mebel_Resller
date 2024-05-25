import 'package:flutter/material.dart';
import 'package:reseller_app/features/landscreen/model/sample_data_model.dart';

class AddToCartUi extends StatelessWidget {
  List<SampleDataModel> cartItems;
  AddToCartUi({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add to cart"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(cartItems[index].productPrice);
              },
            ),
          ),
        ],
      ),
    );
  }
}
