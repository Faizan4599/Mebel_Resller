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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width:
                                          Constant.screenWidth(context) * 0.5,
                                      height:
                                          Constant.screenHeight(context) * 0.2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            data![index].product_url.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: CommonColors.primary,
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      child: Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              print("+");
                                            },
                                            child: const Icon(
                                              size: 30,
                                              Icons.add,
                                              color: CommonColors.planeWhite,
                                            ),
                                          ),
                                          Container(
                                            width: 40,
                                            height:
                                                Constant.screenHeight(context),
                                            color: CommonColors.planeWhite,
                                            child: Center(
                                              child: Text(
                                                data[index].cart_qty.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print("-");
                                            },
                                            child: const Icon(
                                              size: 30,
                                              Icons.remove,
                                              color: CommonColors.planeWhite,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 130,
                                        child: Text(
                                          data[index].name ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: '\u{20B9} ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall),
                                            TextSpan(
                                                text: data[index].price,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 130,
                                        child: Text(
                                          data[index].description ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                      ),
                                      Text(
                                        data[index].category ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      Text(
                                        data[index].subcategory1 ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      Text(
                                        data[index].subcategory2 ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      // ElevatedButton(
                                      //   onPressed: () {},
                                      //   style: ButtonStyle(
                                      //     shape: WidgetStateProperty.all<
                                      //         RoundedRectangleBorder>(
                                      //       RoundedRectangleBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(8.0),
                                      //         side: const BorderSide(
                                      //             width: 1,
                                      //             color: CommonColors.primary),
                                      //       ),
                                      //     ),
                                      //   ),
                                      //   child: const Text('Delete'),
                                      // ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Delete'),
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(30, 40),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                side: BorderSide(
                                                    width: 1,
                                                    color:
                                                        CommonColors.primary))),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Delete'),
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(30, 40),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                side: BorderSide(
                                                    width: 1,
                                                    color:
                                                        CommonColors.primary))),
                                      ),
                                    ],
                                  ),
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









  // Row(
  //                               children: [
  //                                 Column(
  //                                   children: [
  //                                     Row(
  //                                       children: [
  //                                         Column(
  //                                           children: [
  //                                             SizedBox(
  //                                               width: Constant.screenWidth(
  //                                                       context) *
  //                                                   0.5,
  //                                               height: Constant.screenHeight(
  //                                                       context) *
  //                                                   0.3,
  //                                               child: Padding(
  //                                                 padding:
  //                                                     const EdgeInsets.all(8.0),
  //                                                 child: ClipRRect(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           8.0),
  //                                                   child: Image.network(
  //                                                     data![index]
  //                                                         .product_url
  //                                                         .toString(),
  //                                                     fit: BoxFit.cover,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                             Container(
  //                                               height: 40,
  //                                               decoration: BoxDecoration(
  //                                                 color: CommonColors.primary,
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(
  //                                                   8.0,
  //                                                 ),
  //                                               ),
  //                                               child: Row(
  //                                                 // mainAxisAlignment:
  //                                                 //     MainAxisAlignment.spaceBetween,
  //                                                 children: [
  //                                                   InkWell(
  //                                                     onTap: () {
  //                                                       print("+");
  //                                                     },
  //                                                     child: const Icon(
  //                                                       size: 25,
  //                                                       Icons.add,
  //                                                       color: CommonColors
  //                                                           .planeWhite,
  //                                                     ),
  //                                                   ),
  //                                                   Container(
  //                                                     width: 40,
  //                                                     height:
  //                                                         Constant.screenHeight(
  //                                                             context),
  //                                                     color: CommonColors
  //                                                         .planeWhite,
  //                                                     child: Center(
  //                                                       child: Text(
  //                                                         data[index]
  //                                                             .cart_qty
  //                                                             .toString(),
  //                                                         style:
  //                                                             Theme.of(context)
  //                                                                 .textTheme
  //                                                                 .displaySmall,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   InkWell(
  //                                                     onTap: () {
  //                                                       print("-");
  //                                                     },
  //                                                     child: const Icon(
  //                                                       size: 25,
  //                                                       Icons.remove,
  //                                                       color: CommonColors
  //                                                           .planeWhite,
  //                                                     ),
  //                                                   )
  //                                                 ],
  //                                               ),
  //                                             )
  //                                           ],
  //                                         )
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 Column(
  //                                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       data[index].name ?? "",
  //                                       style: Theme.of(context)
  //                                           .textTheme
  //                                           .titleLarge,
  //                                     ),
  //                                     RichText(
  //                                       text: TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                               text: '\u{20B9} ',
  //                                               style: Theme.of(context)
  //                                                   .textTheme
  //                                                   .displaySmall),
  //                                           TextSpan(
  //                                               text: data[index].price,
  //                                               style: Theme.of(context)
  //                                                   .textTheme
  //                                                   .titleLarge),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       data[index].description ?? "",
  //                                       style: Theme.of(context)
  //                                           .textTheme
  //                                           .displaySmall,
  //                                     ),
  //                                     Text(
  //                                       data[index].category ?? "",
  //                                       style: Theme.of(context)
  //                                           .textTheme
  //                                           .displaySmall,
  //                                     ),
  //                                     Text(
  //                                       data[index].subcategory1 ?? "",
  //                                       style: Theme.of(context)
  //                                           .textTheme
  //                                           .displaySmall,
  //                                     ),
  //                                     Text(
  //                                       data[index].subcategory2 ?? "",
  //                                       style: Theme.of(context)
  //                                           .textTheme
  //                                           .displaySmall,
  //                                     ),
  //                                     ElevatedButton(
  //                                         onPressed: () {},
  //                                         style: ButtonStyle(
  //                                             shape: WidgetStateProperty.all<
  //                                                     RoundedRectangleBorder>(
  //                                                 RoundedRectangleBorder(
  //                                                     borderRadius:
  //                                                         BorderRadius.circular(
  //                                                             8.0),
  //                                                     side: const BorderSide(
  //                                                         color: CommonColors
  //                                                             .primary)))),
  //                                         child: const Text('Delete'))
  //                                   ],
  //                                 )
  //                               ],
  //                             ),