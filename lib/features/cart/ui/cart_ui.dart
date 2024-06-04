// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/cart/bloc/cart_bloc.dart';

import 'package:reseller_app/features/landscreen/model/get_product_data_model.dart';
import 'package:reseller_app/utils/common_colors.dart';

class CartUi extends StatelessWidget {
  CartUi({
    Key? key,
    required this.cartItems,
  }) : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _cartBloc.add(GetDataEvent());
      },
    );
  }
  List<GetProductDataModel> cartItems;
  CartBloc _cartBloc = CartBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          BlocBuilder<CartBloc, CartState>(
            bloc: _cartBloc,
            buildWhen: (previous, current) => current is CartSuccessState,
            builder: (context, state) {
              if (state is CartSuccessState) {
                var data = state.data;
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: Constant.screenWidth(context),
                          decoration: const BoxDecoration(
                            color: Color(0x34C4C4C4),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            Constant.screenWidth(context) * 0.5,
                                        height: Constant.screenHeight(context) *
                                            0.3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              data![index]
                                                  .product_url
                                                  .toString(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                print("+");
                                              },
                                              child: const Icon(
                                                size: 26,
                                                Icons.add,
                                                color: CommonColors.planeWhite,
                                              ),
                                            ),
                                            Container(
                                              width: 40,
                                              color: CommonColors.planeWhite,
                                              child: Center(
                                                child: Text(data[index]
                                                    .cart_qty
                                                    .toString()),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                print("-");
                                              },
                                              child: const Icon(
                                                size: 26,
                                                Icons.remove,
                                                color: CommonColors.planeWhite,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(data[index].name ?? ""),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
