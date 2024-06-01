import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/add_to_cart/ui/add_to_cart.dart';
import 'package:reseller_app/features/landscreen/model/get_product_data_model.dart';
import 'package:reseller_app/utils/common_colors.dart';

import '../../landscreen/model/sample_data_model.dart';
import '../bloc/product_bloc.dart';

class ProductUi extends StatelessWidget {
  final ProductBloc _ProductBloc = ProductBloc();

  final List<GetProductDataModel> perticularData;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  ProductUi({Key? key, required this.perticularData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetProductDataModel allData = perticularData.first;

    ;
    print("<<<<<<<<<<${allData}");

    return BlocProvider(
      create: (_) => ProductBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Product"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
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
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            final productBloc =
                                BlocProvider.of<ProductBloc>(context);
                            return PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                productBloc.add(
                                    ProductSlideImageEvent(currentPage: index));

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocListener<ProductBloc, ProductState>(
                      bloc: _ProductBloc,
                      listenWhen: (previous, current) =>
                          current is ProductActionState,
                      listener: (context, state) {
                        if (state is ProductNavigateToAddToCartState) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddToCartUi(
                                  cartItems: perticularData,
                                ),
                              ));
                        }
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          _ProductBloc.add(ProductGotoAddToCartEvent());
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
                const Row(
                  children: [
                    Text(
                      "Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(allData.description ?? ""),
                      ],
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
                    productInfo("Product Name", allData.name.toString()),
                    productInfo("Region", allData.region.toString()),
                    productInfo("Category", allData.category.toString()),
                    productInfo("Subcategory", allData.subcategory1.toString()),
                    productInfo(
                        "Subcategory 2", allData.subcategory2.toString()),
                    productInfo("Price", allData.price.toString()),
                    productInfo("Poduct ID", allData.product_id.toString()),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget productInfo(String title, String infoData) {
    return Padding(
      padding: const EdgeInsets.only(top: 5,bottom: 5),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title :  ',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black, // Specify the color if needed
                  ),
                ),
                TextSpan(
                  text: infoData,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Specify the color if needed
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
