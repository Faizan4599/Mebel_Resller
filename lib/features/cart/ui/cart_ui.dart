// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/common/widgets/common_dialog.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/cart/bloc/cart_bloc.dart';
import 'package:reseller_app/features/getQuote/ui/get_quote_ui.dart';
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
      floatingActionButton: Container(
        padding: EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.bottomRight,
          child: BlocListener<CartBloc, CartState>(
            bloc: _cartBloc,
            listenWhen: (previous, current) =>
                current is CartNavigateToGetQuoteScreenState,
            listener: (context, state) {
              if (state is CartNavigateToGetQuoteScreenState) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GetQuoteUI(),
                    )).then(
                  (_) {
                    _cartBloc.add(GetDataEvent());
                  },
                );
              }
            },
            child: FloatingActionButton.extended(
              backgroundColor: CommonColors.primary,
              onPressed: () {
                _cartBloc.add(CartNavigateToGetQuoteScreenEvent());
              },
              icon: Icon(
                Icons.book_online_outlined,
                color: CommonColors.planeWhite,
              ),
              label: Text(
                "Get Quote",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginUi(),
                  ),
                );
              }
            },
            child: IconButton(
              onPressed: () {
                showCommonDialog(
                    dialogTitle: "Logout",
                    dialogMessage: "Are you sure you want to logout?",
                    buttonTitle: "Logout",
                    context: context,
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onEvent: () {
                      _landBloc.add(LandLogoutEvent());
                      Navigator.pop(context);
                    });
              },
              icon: const Icon(Icons.logout_outlined),
              iconSize: 27,
              color: CommonColors.planeWhite,
            ),
          )
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        bloc: _cartBloc,
        buildWhen: (previous, current) =>
            current is CartSuccessState || current is CartLoadingState,
        builder: (context, state) {
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $state");
          if (state is CartSuccessState) {
            var data = state.data;
            return (data != null && data.isNotEmpty)
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
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
                                          width: (kIsWeb)
                                              ? 170
                                              : Constant.screenWidth(context) *
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
                                                data[index]
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
                                                  BlocListener<CartBloc,
                                                      CartState>(
                                                    bloc: _cartBloc,
                                                    listenWhen: (previous,
                                                            current) =>
                                                        current
                                                            is CartAddCountState,
                                                    listener: (context, state) {
                                                      if (state
                                                          is CartAddCountState) {
                                                        final currentTime =
                                                            DateTime.now();
                                                        if (_cartBloc
                                                                    .lastToastTime ==
                                                                null ||
                                                            currentTime
                                                                    .difference(
                                                                        _cartBloc
                                                                            .lastToastTime!)
                                                                    .inMilliseconds >
                                                                500) {
                                                          Constant.showShortToast(
                                                              state.message ??
                                                                  "");
                                                          _cartBloc
                                                                  .lastToastTime =
                                                              currentTime;
                                                        }
                                                      }
                                                    },
                                                    child: InkWell(
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
                                                        size: 25,
                                                        Icons.add,
                                                        color: CommonColors
                                                            .planeWhite,
                                                      ),
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
                                                          .bodyMedium,
                                                    )),
                                                  ),
                                                  BlocListener<CartBloc,
                                                      CartState>(
                                                    bloc: _cartBloc,
                                                    listenWhen: (previous,
                                                            current) =>
                                                        current
                                                            is CartRemoveCountState,
                                                    listener: (context, state) {
                                                      if (state
                                                          is CartRemoveCountState) {
                                                        final currentTime =
                                                            DateTime.now();
                                                        if (_cartBloc
                                                                    .lastToastTime ==
                                                                null ||
                                                            currentTime
                                                                    .difference(
                                                                        _cartBloc
                                                                            .lastToastTime!)
                                                                    .inMilliseconds >
                                                                500) {
                                                          Constant.showShortToast(
                                                              state.message ??
                                                                  "");
                                                          _cartBloc
                                                                  .lastToastTime =
                                                              currentTime;
                                                        }
                                                      }
                                                    },
                                                    child: InkWell(
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
                                                        size: 25,
                                                        Icons.remove,
                                                        color: CommonColors
                                                            .planeWhite,
                                                      ),
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
                                                  final currentTime =
                                                      DateTime.now();
                                                  if (_cartBloc.lastToastTime ==
                                                          null ||
                                                      currentTime
                                                              .difference(_cartBloc
                                                                  .lastToastTime!)
                                                              .inMilliseconds >
                                                          500) {
                                                    Constant.showShortToast(
                                                        state.message);
                                                    _cartBloc.lastToastTime =
                                                        currentTime;
                                                  }
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
                  )
                : SizedBox(
                    height: Constant.screenHeight(context) * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_cart,
                            size: 40,
                          ),
                          Text(
                            'Currently no products in the cart',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  );
          } else if (state is CartLoadingState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(),
                Center(
                  child: Constant.spinKitLoader(context, CommonColors.primary),
                ),
                const SizedBox()
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
