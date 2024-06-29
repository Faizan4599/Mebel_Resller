import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/cart/ui/cart_ui.dart';
import 'package:reseller_app/features/landscreen/bloc/land_bloc.dart';
import 'package:reseller_app/features/landscreen/model/get_product_data_model.dart';
import 'package:reseller_app/features/landscreen/ui/landui.dart';
import 'package:reseller_app/features/login/ui/login_ui.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/utils/common_colors.dart';
import '../../../constant/custom_scroll_behavior.dart';
import '../bloc/product_bloc.dart';

class ProductUi extends StatelessWidget {
  final ProductBloc _productBloc = ProductBloc();
  final LandBloc _landBloc = LandBloc();
  int qty = 0;
  final List<GetProductDataModel> perticularData;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  ProductUi({Key? key, required this.perticularData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetProductDataModel allData = perticularData.first;

    _landBloc.add(LandCartCountEvent(data: []));
    qty = int.parse(allData.cart_qty.toString());
    return BlocProvider(
      create: (_) => ProductBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Product"),
          actions: [
            BlocListener<ProductBloc, ProductState>(
              bloc: _productBloc,
              listenWhen: (previous, current) =>
                  current is ProductNavigateToAddToLandScreenState,
              listener: (context, state) {
                if (state is ProductNavigateToAddToLandScreenState) {
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
                  // _cartBloc.add(CartNavigateToLandScreenEvent());
                  _productBloc.add(ProductNavigateToLandScreenEvent());
                },
                icon: Icon(Icons.home_outlined),
                iconSize: 27,
                color: CommonColors.planeWhite,
              ),
            ),
            Badge(
              // alignment: Alignment.topLeft,
              alignment: Alignment.topCenter,
              backgroundColor: CommonColors.planeWhite,
              label: BlocProvider.value(
                value: _landBloc,
                child: BlocBuilder<LandBloc, LandState>(
                  bloc: _landBloc,
                  buildWhen: (previous, current) =>
                      current is LandCartCountState,
                  builder: (context, state) {
                    print("CNCNC State ${state}");
                    if (state is LandCartCountState) {
                      return Text(
                        state.data!.first.cart_count.toString(),
                        style: const TextStyle(
                            fontSize: 11, color: CommonColors.primary),
                      );
                    } else {
                      return const Text(
                        "0",
                        style: TextStyle(
                            fontSize: 11, color: CommonColors.primary),
                      );
                    }
                  },
                ),
              ),
              child: BlocListener<LandBloc, LandState>(
                bloc: _landBloc,
                listenWhen: (previous, current) =>
                    current is LandNavigateToCartState,
                listener: (context, state) {
                  if (state is LandNavigateToCartState) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartUi(cartItems: []),
                        )).then((_) {
                      // print("SSSSSSSSSSSS $val");
                      _landBloc.add(LandCartCountEvent(data: []));
                    });
                  }
                },
                child: IconButton(
                  onPressed: () {
                    _landBloc.add(LandNavigateToCartEvent());
                  },
                  icon: Icon(Icons.shopping_cart_outlined),
                  iconSize: 27,
                  color: CommonColors.planeWhite,
                ),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: Constant.screenWidth(context),
                        height: Constant.screenHeight(context) * 0.3,
                        decoration: const BoxDecoration(
                          color: Color(0x34C4C4C4),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            final productBloc =
                                BlocProvider.of<ProductBloc>(context);
                            return PageView.builder(
                              controller: _pageController,
                              scrollBehavior: CustomScrollBehavior(),
                              onPageChanged: (index) {
                                productBloc.add(
                                  ProductSlideImageEvent(currentPage: index),
                                );
                                // Automatically scroll the dots to keep the current one visible
                                _scrollController.animateTo(
                                  index * 21.0, // width of each dot + padding
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              itemCount: allData.product_urls?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      // await OpenFile.open(images[index]);
                                    },
                                    child: Container(
                                      width: 160,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Image.network(
                                        allData.product_urls![index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          final currentPage = state is ProductSlideImageState
                              ? state.currentPage
                              : 0;

                          return Container(
                            height: 30,
                            width: 140,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(52, 196, 196, 196),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    allData.product_urls?.length ?? 0,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Container(
                                          // height: 13,
                                          width: currentPage == index ? 12 : 7,
                                          decoration: BoxDecoration(
                                            color: currentPage == index
                                                ? CommonColors.primary
                                                : Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<ProductBloc, ProductState>(
                  bloc: _productBloc,
                  builder: (context, state) {
                    return (qty > 0 || _productBloc.addToCart)
                        ? const Text(
                            "Item is already added to the cart",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.red),
                          )
                        : const SizedBox();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocListener<ProductBloc, ProductState>(
                      bloc: _productBloc,
                      listenWhen: (previous, current) =>
                          current is ProductNavigateToAddToCartState ||
                          current is ProductSuccessState ||
                          current is ProductErrorState,
                      listener: (context, state) {
                        print("Check state .....${state}");
                        if (state is ProductSuccessState) {
                          Constant.showShortToast(state.message);
                        } else if (state is ProductErrorState) {
                          Constant.showShortToast(state.message);
                        } else if (state is ProductNavigateToAddToCartState) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartUi(
                                cartItems: perticularData,
                              ),
                            ),
                          ).then((_) {
                            _landBloc.add(LandCartCountEvent(data: []));
                          });
                        }
                      },
                      child: ElevatedButton(
                        onPressed: () async {
                          _productBloc.add(ProductGotoAddToCartEvent(
                              product_id: allData.product_id ?? ""));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          backgroundColor: CommonColors.primary,
                        ),
                        child: const Text(
                          "Add to cart",
                          style: TextStyle(color: CommonColors.planeWhite),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      allData.name ?? "",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 2,
                  color: Color(0x34C4C4C4),
                ),
                Column(
                  children: [
                    productInfo("Price", allData.price.toString(), context),
                    productInfo(
                        "Product ID", allData.product_id.toString(), context),
                    productInfo("Region", allData.region.toString(), context),
                    productInfo(
                        "Style", allData.style_name.toString(), context),
                    productInfo(
                        "Category", allData.category.toString(), context),
                    productInfo("Subcategory", allData.subcategory1.toString(),
                        context),
                    productInfo("Subcategory 2",
                        allData.subcategory2.toString(), context),
                    productInfo("Description", allData.description.toString(),
                        context),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget productInfo(String title, String infoData, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title :  ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: infoData,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
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
            height: 125,
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
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        (dialogType == "download")
                            ? "Do you want to download the images?"
                            : "Are you sure you want to logout?",
                        style: Theme.of(context).textTheme.bodyMedium,
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
