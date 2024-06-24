// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/cart/bloc/cart_bloc.dart';
import 'package:reseller_app/features/landscreen/bloc/land_bloc.dart';

import 'package:reseller_app/features/landscreen/model/get_product_data_model.dart';
import 'package:reseller_app/features/landscreen/ui/landui.dart';
import 'package:reseller_app/features/login/ui/login_ui.dart';
import 'package:reseller_app/helper/preference_utils.dart';
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
  LandBloc _landBloc = LandBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          BlocListener<CartBloc, CartState>(
            bloc: _cartBloc,
            listenWhen: (previous, current) =>
                current is CartNavigateToLandScreenState,
            listener: (context, state) {
              if (state is CartNavigateToLandScreenState) {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => LandUi(),
                //   ),
                // );
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => LandUi(),
                  ),
                  (route) =>
                      false, //if you want to disable back feature set to false
                );
              }
            },
            child: IconButton(
              onPressed: () {
                _cartBloc.add(CartNavigateToLandScreenEvent());
              },
              icon: Icon(Icons.home_outlined),
              iconSize: 27,
              color: CommonColors.planeWhite,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          BlocListener<LandBloc, LandState>(
            bloc: _landBloc,
            listenWhen: (previous, current) => current is LandLogoutState,
            listener: (context, state) async {
              if (state is LandLogoutState) {
                Navigator.pop(context); // Close the dialog if it's open
                await PreferenceUtils.clearData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginUi(),
                  ),
                );
              }
            },
            child: IconButton(
              onPressed: () {
                _showDownloadDialog(context, "logout");
              },
              icon: const Icon(Icons.logout_outlined),
              iconSize: 27,
              color: CommonColors.planeWhite,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<CartBloc, CartState>(
            bloc: _cartBloc,
            buildWhen: (previous, current) => current is CartSuccessState,
            builder: (context, state) {
              print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $state");
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
                          height: Constant.screenHeight(context) * 0.3,
                          decoration: const BoxDecoration(
                            color: Color(0x34C4C4C4),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: Constant.screenWidth(context) *
                                              0.5,
                                          height:
                                              Constant.screenHeight(context) *
                                                  0.2,
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: CommonColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8.0,
                                                ),
                                              ),
                                              child: Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _cartBloc.add(
                                                        CartAddCountEvent(
                                                            product_id: data[
                                                                        index]
                                                                    .product_id ??
                                                                ""),
                                                      );
                                                    },
                                                    child: const Icon(
                                                      size: 30,
                                                      Icons.add,
                                                      color: CommonColors
                                                          .planeWhite,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    height:
                                                        Constant.screenHeight(
                                                            context),
                                                    color:
                                                        CommonColors.planeWhite,
                                                    child: Center(
                                                        child: Text(
                                                      state
                                                          .data![index].cart_qty
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge,
                                                    )),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _cartBloc.add(
                                                        CartRemoveCountEvent(
                                                            product_id: data[
                                                                        index]
                                                                    .product_id ??
                                                                ""),
                                                      );
                                                      print("-");
                                                    },
                                                    child: const Icon(
                                                      size: 30,
                                                      Icons.remove,
                                                      color: CommonColors
                                                          .planeWhite,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            BlocListener<CartBloc, CartState>(
                                              bloc: _cartBloc,
                                              listenWhen: (previous, current) =>
                                                  current
                                                      is CartDeleteSingleItemState,
                                              listener: (context, state) {
                                                if (state
                                                    is CartDeleteSingleItemState) {
                                                  Constant.showShortToast(
                                                      state.message);
                                                }
                                              },
                                              child: IconButton(
                                                iconSize: 30,
                                                color: Colors.red,
                                                onPressed: () {
                                                  _cartBloc.add(
                                                      CartDeleteSingleItem(
                                                          productId: data[index]
                                                              .product_id
                                                              .toString()));
                                                },
                                                icon: const Icon(
                                                    Icons.delete_forever),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height:
                                        Constant.screenHeight(context) * 0.3,
                                    // color: Colors.black,
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.cancel),
                                        // SizedBox(
                                        //   height: 15,
                                        // ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 160,
                                              child: Text(
                                                maxLines: 2,
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
                                                          .bodyMedium),
                                                  TextSpan(
                                                      text: data[index].price,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              data[index].subcategory2 ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            Text(
                                              data[index].region ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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

  void _showDownloadDialog(BuildContext context, String dialogType) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            // color: Colors.greenAccent,
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        (dialogType == "download")
                            ? "Download Images"
                            : "Logout",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        (dialogType == "download")
                            ? "Do you want to download the images?"
                            : "Are you sure you want to logout?",
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: CommonColors.primary,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: CommonColors.primary,
                          ),
                          onPressed: () async {
                            // _landBloc.add(LandDownloadImageEvent(
                            //     data: _landBloc.selectedData));
                            // Navigator.pop(context);
                            if (dialogType == "download") {
                              // _landBloc.add(LandDownloadImageEvent(
                              //     data: _landBloc.selectedData));
                            } else if (dialogType == "logout") {
                              //  Navigator.pop(context);
                              _landBloc.add(LandLogoutEvent());
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            (dialogType == "download") ? "Download" : "Logout",
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
