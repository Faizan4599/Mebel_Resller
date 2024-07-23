import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/common/widgets/common_dialog.dart';
import 'package:reseller_app/common/widgets/text_field.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/allQuotes/ui/all_quotes_ui.dart';
import 'package:reseller_app/features/cart/ui/cart_ui.dart';
import 'package:reseller_app/features/landscreen/bloc/land_bloc.dart';
import 'package:reseller_app/features/login/ui/login_ui.dart';
import 'package:reseller_app/features/Product/ui/product_ui.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/utils/common_colors.dart';

class LandUi extends StatelessWidget {
  LandUi({Key? key}) : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // _landBloc.add(LoadDataEvent());
        _landBloc.add(LoadDataEvent());
        _landBloc.add(
            LandCategoryDropDownEvent(categoryDropDownValue: '', items: []));
        _landBloc
            .add(LandRegionDropDownEvent(regionDropDownValue: '', items: []));
        _landBloc.add(LandCartCountEvent(data: []));
        _landBloc.add(LandStyleDropDownEvent());
        _landBloc.add(LandCartCountEvent(data: []));
        _landBloc.add(LandLoadtAllQuotesEvent());
      },
    );
  }
  final TextEditingController txt1 = TextEditingController();
  final TextEditingController txt2 = TextEditingController();
  final TextEditingController productId = TextEditingController();
  final _landBloc = LandBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          PreferenceUtils.getString(UserData.name.name),
          style: const TextStyle(color: CommonColors.planeWhite),
        ),
        // backgroundColor: CommonColors.primary,
        actions: [
          BlocListener<LandBloc, LandState>(
            bloc: _landBloc,
            listenWhen: (previous, current) =>
                current is LandNavigateToAllQuotesState,
            listener: (context, state) {
              if (state is LandNavigateToAllQuotesState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllQuotesUI(
                        quotesList: state.quotesList,
                      ),
                    ));
              }
              // TODO: implement listener
            },
            child: IconButton(
              onPressed: () {
                _landBloc.add(LandNavigateToAllQuotesEvent());
              },
              icon: const Icon(
                Icons.book_online_outlined,
                color: CommonColors.planeWhite,
              ),
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
                buildWhen: (previous, current) => current is LandCartCountState,
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
                      style:
                          TextStyle(fontSize: 11, color: CommonColors.primary),
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
          const SizedBox(
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
                    ));
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
      body: BlocProvider.value(
        value: _landBloc,
        child: RefreshIndicator(
          onRefresh: () async {
            _landBloc.add(LandRefreshDataEvent());
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  _landBloc.hasMoreData) {
                _landBloc.add(LandLoadNextPageEvent());
                return true;
              }
              return false;
            },
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CommonColors.primary,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      height: 50,
                      width: Constant.screenWidth(context),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Filters",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                InkWell(
                                  onTap: () {
                                    _landBloc.add(
                                      LandDropdownEvent(value: _landBloc.show),
                                    );
                                  },
                                  child: BlocBuilder<LandBloc, LandState>(
                                    bloc: _landBloc,
                                    builder: (context, state) {
                                      return Icon(
                                        color: CommonColors.secondary,
                                        _landBloc.show
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        size: 30,
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<LandBloc, LandState>(
                  bloc: _landBloc,
                  builder: (context, state) {
                    return (_landBloc.show)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            child: Container(
                              color: CommonColors.secondary,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        customDropDownButton(
                                          title: "REGION",
                                          context: context,
                                          isExpanded: true,
                                          hint: "Select Region",
                                          value: _landBloc.regionVal == ''
                                              ? null
                                              : _landBloc.regionVal,
                                          items: _landBloc.regionList
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.region_id,
                                                    child: Text(
                                                      item.region_name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            _landBloc.regionVal = value!;
                                            _landBloc.add(
                                              LandRegionDropDownEvent(
                                                  regionDropDownValue: _landBloc
                                                      .sortDropdownValue,
                                                  items: _landBloc.regionList),
                                            );
                                          },
                                        ),
                                        customDropDownButton(
                                          title: "CATEGORY",
                                          hint: "Select Category",
                                          context: context,
                                          isExpanded: true,
                                          value: _landBloc.categoryVal == ''
                                              ? null
                                              : _landBloc.categoryVal,
                                          items: _landBloc.categoryList
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.category_id,
                                                    child: Text(
                                                      item.category_name ?? "",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) async {
                                            _landBloc.categoryVal = value!;
                                            // _landBloc.add(LandCategoryDropDownEvent(
                                            //     categoryDropDownValue:
                                            //         _landBloc.categoryVal,
                                            //     items: _landBloc.categoryList));

                                            _landBloc.add(
                                                LandSubcategoryDropDownEvent(
                                                    subCategoryDropDownValue:
                                                        '',
                                                    items: [],
                                                    category_id: value));
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        customDropDownButton(
                                          title: "SUBCATEGORY",
                                          hint: "Select Subcategory 1",
                                          context: context,
                                          isExpanded: true,
                                          value: _landBloc.subCategoryVal == ''
                                              ? null
                                              : _landBloc.subCategoryVal,
                                          items: _landBloc.subCategoryList
                                              .map(
                                                (item) =>
                                                    DropdownMenuItem<String>(
                                                  value: item.subcategory1_id,
                                                  child: Text(
                                                    item.subcategory1_name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) async {
                                            print(
                                                "VALUE of subcategory $value");
                                            print(
                                                "+++++ ${_landBloc.subCategoryVal}");
                                            _landBloc.subCategoryVal = value!;
                                            _landBloc.add(
                                                LandSubcategory2DropDownEvent(
                                                    subcategory2DropDownValue:
                                                        '',
                                                    subCategoryId: value,
                                                    items: []));
                                            _landBloc.add(
                                                LandSubcategoryDropDownEvent(
                                                    subCategoryDropDownValue:
                                                        '',
                                                    items: [],
                                                    category_id: ''));
                                          },
                                        ),
                                        customDropDownButton(
                                          context: context,
                                          hint: "Select Subcategory 2",
                                          isExpanded: true,
                                          items: _landBloc.subCategory2List
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.subcategory2_id,
                                                    child: Text(
                                                      item.subcategory2_name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            _landBloc.subCategory2Val = value!;
                                            _landBloc.add(
                                              LandSubcategory2DropDownEvent(
                                                  subcategory2DropDownValue:
                                                      value,
                                                  subCategoryId: '',
                                                  items: []),
                                            );
                                          },
                                          title: "SUBCATEGORY 2",
                                          value: _landBloc.subCategory2Val == ''
                                              ? null
                                              : _landBloc.subCategory2Val,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        customDropDownButton(
                                          title: "STYLE",
                                          context: context,
                                          isExpanded: true,
                                          hint: "Select Style",
                                          value: _landBloc.styleVal == ''
                                              ? null
                                              : _landBloc.styleVal,
                                          items: _landBloc.styleList
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.style_id,
                                                    child: Text(
                                                      item.style_name ?? "",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            _landBloc.styleVal = value!;
                                            _landBloc
                                                .add(LandStyleDropDownEvent());
                                          },
                                        ),
                                        customTextfield(
                                            title: "PRODUCT ID",
                                            titleStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                            txtHeight: 45,
                                            txtWidth: (kIsWeb)
                                                ? 150
                                                : Constant.screenWidth(
                                                        context) *
                                                    0.4,
                                            txtStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            cursorColor: CommonColors.primary,
                                            controller: productId,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: CommonColors.primary,
                                                  width: 2),
                                            ),
                                            hintText: "Enter product id",
                                            hintStyle: TextStyle(fontSize: 13),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.zero)),
                                        // Column(
                                        //   // mainAxisAlignment: MainAxisAlignment.start,
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     Text(
                                        //       "PRODUCT ID",
                                        //       style: Theme.of(context)
                                        //           .textTheme
                                        //           .labelLarge,
                                        //     ),
                                        //     SizedBox(
                                        //       height: 45,
                                        //       width: (kIsWeb)
                                        //           ? 150
                                        //           : Constant.screenWidth(
                                        //                   context) *
                                        //               0.4,
                                        //       child: TextField(
                                        //         style: Theme.of(context)
                                        //             .textTheme
                                        //             .bodyMedium,
                                        //         keyboardType:
                                        //             TextInputType.number,
                                        //         inputFormatters: <TextInputFormatter>[
                                        //           FilteringTextInputFormatter
                                        //               .digitsOnly
                                        //         ],
                                        //         cursorColor:
                                        //             CommonColors.primary,
                                        //         controller: productId,
                                        //         decoration:
                                        //             const InputDecoration(
                                        //                 // isDense: true,
                                        //                 contentPadding:
                                        //                     EdgeInsets.all(10),
                                        //                 // contentPadding: edgein,
                                        //                 focusedBorder:
                                        //                     OutlineInputBorder(
                                        //                   borderSide: BorderSide(
                                        //                       color:
                                        //                           CommonColors
                                        //                               .primary,
                                        //                       width: 2),
                                        //                 ),
                                        //                 hintText:
                                        //                     "Enter product id",
                                        //                 hintStyle: TextStyle(
                                        //                     fontSize: 13),
                                        //                 border:
                                        //                     OutlineInputBorder(
                                        //                         borderRadius:
                                        //                             BorderRadius
                                        //                                 .zero)),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "PRICE RANGE",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                            BlocProvider(
                                              create: (context) => LandBloc(),
                                              child: Text(
                                                "\u{20B9} ${_landBloc.start} - \u{20B9} ${_landBloc.end}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                        BlocBuilder<LandBloc, LandState>(
                                          bloc: _landBloc,
                                          builder: (context, state) {
                                            return BlocProvider.value(
                                              // create: (context) => LandBloc(),
                                              value: _landBloc,
                                              child: RangeSlider(
                                                values: RangeValues(
                                                    _landBloc.start.toDouble(),
                                                    _landBloc.end.toDouble()),
                                                labels: RangeLabels(
                                                    _landBloc.start.toString(),
                                                    _landBloc.end.toString()),
                                                onChanged: (value) {
                                                  _landBloc.add(
                                                      LandPriceRangeSliderEvent(
                                                          start:
                                                              _landBloc.start,
                                                          end: _landBloc.end));
                                                },
                                                onChangeStart: (value) {
                                                  _landBloc.add(
                                                      LandPriceRangeSliderEvent(
                                                          start:
                                                              _landBloc.start,
                                                          end: _landBloc.end));
                                                },
                                                onChangeEnd: (value) {
                                                  _landBloc.add(
                                                      LandPriceRangeSliderEvent(
                                                          start: value.start
                                                              .toInt(),
                                                          end: value.end
                                                              .toInt()));
                                                },
                                                min: 1000.0,
                                                max: 500000.0,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ButtonTheme(
                                          minWidth: 200,
                                          height: 40,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _landBloc.show = false;
                                              // bool isFilterSelected = _landBloc
                                              //         .regionVal.isNotEmpty ||
                                              //     _landBloc.categoryVal.isNotEmpty ||
                                              //     _landBloc
                                              //         .subCategoryVal.isNotEmpty ||
                                              //     _landBloc
                                              //         .subCategory2Val.isNotEmpty ||
                                              //     productId.text.isNotEmpty;

                                              // if (isFilterSelected) {

                                              // } else {
                                              //   Constant.showLongToast(
                                              //       'Please select at least one filter.');
                                              // }
                                              _landBloc.add(
                                                LandSearchDataEvent(
                                                    startRange: _landBloc.start,
                                                    endRange: _landBloc.end,
                                                    regionId: _landBloc
                                                            .regionVal.isEmpty
                                                        ? null
                                                        : _landBloc.regionVal,
                                                    categoryId: _landBloc
                                                            .categoryVal.isEmpty
                                                        ? null
                                                        : _landBloc.categoryVal,
                                                    subCategoryId: _landBloc
                                                            .subCategoryVal
                                                            .isEmpty
                                                        ? null
                                                        : _landBloc
                                                            .subCategoryVal,
                                                    subCategory2Id: _landBloc
                                                            .subCategory2Val
                                                            .isEmpty
                                                        ? null
                                                        : _landBloc
                                                            .subCategory2Val,
                                                    productId:
                                                        productId.text.isEmpty
                                                            ? null
                                                            : productId.text,
                                                    styleId: _landBloc
                                                            .styleVal.isEmpty
                                                        ? null
                                                        : _landBloc.styleVal),
                                              );
                                              // _landBloc.add(LandClearDataEvent(
                                              //     value: _landBloc.regionVal,
                                              //     list: _landBloc.regionList));
                                              // _landBloc.add(LandClearDataEvent(
                                              //     value: _landBloc.categoryVal,
                                              //     list: _landBloc.categoryList));
                                              // _landBloc.add(LandClearDataEvent(
                                              //     value: _landBloc.subCategoryVal,
                                              //     list: _landBloc.subCategoryList));
                                              // _landBloc.add(LandClearDataEvent(
                                              //     value: _landBloc.subCategory2Val,
                                              //     list: _landBloc.subCategory2List));
                                              // productId.text = '';

                                              // _landBloc.add(LandCategoryDropDownEvent(
                                              //     categoryDropDownValue: '',
                                              //     items: []));
                                              // _landBloc.add(LandRegionDropDownEvent(
                                              //     regionDropDownValue: '',
                                              //     items: []));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              backgroundColor:
                                                  CommonColors.primary,
                                            ),
                                            child: const Text(
                                              "SEARCH",
                                              style: TextStyle(
                                                  color:
                                                      CommonColors.planeWhite),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ButtonTheme(
                                          minWidth: 200,
                                          height: 40,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _landBloc.add(LandClearDataEvent(
                                                  value: _landBloc.regionVal,
                                                  list: _landBloc.regionList));
                                              _landBloc.add(LandClearDataEvent(
                                                  value: _landBloc.categoryVal,
                                                  list:
                                                      _landBloc.categoryList));
                                              _landBloc.add(LandClearDataEvent(
                                                  value:
                                                      _landBloc.subCategoryVal,
                                                  list: _landBloc
                                                      .subCategoryList));
                                              _landBloc.add(LandClearDataEvent(
                                                  value:
                                                      _landBloc.subCategory2Val,
                                                  list: _landBloc
                                                      .subCategory2List));

                                              _landBloc.add(LandClearDataEvent(
                                                  value: _landBloc.styleVal,
                                                  list: _landBloc.styleList));
                                              productId.text = '';

                                              _landBloc.add(
                                                  LandCategoryDropDownEvent(
                                                      categoryDropDownValue: '',
                                                      items: []));
                                              _landBloc.add(
                                                  LandRegionDropDownEvent(
                                                      regionDropDownValue: '',
                                                      items: []));

                                              _landBloc.add(
                                                  LandStyleDropDownEvent());

                                              _landBloc.regionVal = '';
                                              _landBloc.styleVal = '';
                                              _landBloc.start = 1000;
                                              _landBloc.end = 100000;
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              backgroundColor:
                                                  CommonColors.primary,
                                            ),
                                            child: const Text(
                                              "RESET",
                                              style: TextStyle(
                                                  color:
                                                      CommonColors.planeWhite),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                ),
                Expanded(
                  child: BlocBuilder<LandBloc, LandState>(
                    buildWhen: (previous, current) =>
                        current is LoadDataState ||
                        current is LandLoadMoreDataState ||
                        current is LandSearchDataState ||
                        current is LandSearchDataNotFoundState ||
                        current is LandLoadingState,
                    bloc: _landBloc,
                    builder: (context, state) {
                      print("STATE CHECK FOR PRODUCTS>>>> $state");
                      if (state is LoadDataState ||
                          state is LandLoadMoreDataState ||
                          state is LandSearchDataState) {
                        var data = (state is LoadDataState)
                            ? state.data
                            : (state is LandLoadMoreDataState)
                                ? state.data
                                : (state as LandSearchDataState).filteredData;
                        return BlocListener<LandBloc, LandState>(
                          bloc: _landBloc,
                          listenWhen: (previous, current) =>
                              current is LandNavigateToQuoteState,
                          listener: (context, state) {
                            if (state is LandNavigateToQuoteState) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductUi(
                                    perticularData: state.productData ?? [],
                                  ),
                                ),
                              ).then((_) {
                                // print("SSSSSSSSSSSS $val");
                                _landBloc.add(LandCartCountEvent(data: []));
                              });
                              ;
                            }
                          },
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 6, right: 6, top: 5, bottom: 5),
                                child: InkWell(
                                  onTap: () {
                                    _landBloc.add(
                                      LandNavigateToQuoteEvent(
                                          productId: data[index].product_id),
                                    );
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: CommonColors.primary),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                data[index].product_id ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              // IconButton(
                                              //   onPressed: () {},
                                              //   icon: const Icon(Icons.share),
                                              //   iconSize: 20,
                                              //   color: Colors.white,
                                              // ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: InkWell(
                                                    onTap: () {},
                                                    child: const Icon(
                                                      Icons.share,
                                                      color: CommonColors
                                                          .planeWhite,
                                                      size: 23,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    data[index].product_url ??
                                                        ""),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       top: 10, bottom: 10),
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     children: [
                                        //       Text(
                                        //         "\u{20B9} ${data[index].price}",
                                        //         style: const TextStyle(
                                        //             fontSize: 15,
                                        //             color: Colors.white),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 10,
                                            right: 10,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: (kIsWeb)
                                                        ? 200
                                                        : Constant.screenWidth(
                                                                context) *
                                                            0.6,
                                                    child: Text(
                                                      data[index]
                                                          .name
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        data[index]
                                                            .region
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .arrow_right_outlined,
                                                        size: 20,
                                                        color: CommonColors
                                                            .planeWhite,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        data[index]
                                                            .style_name
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "\u{20B9} ${data[index].price}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is LandLoadingState) {
                        return Center(
                          child: Constant.spinKitLoader(
                              context, CommonColors.primary),
                        );
                      } else if (state is LandSearchDataNotFoundState) {
                        return Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 40,
                                ),
                                Text(
                                  state.msg,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // return const Center(child: CircularProgressIndicator());
                        return const Center(child: SizedBox());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customDropDownButton({
    required String? title,
    required BuildContext context,
    required bool isExpanded,
    Color? containerColor,
    Color? dropdownColor,
    Color? iconEnabledColor,
    required String? value,
    required List<DropdownMenuItem<String>>? items,
    // BorderRadius? borderRadius,
    required void Function(String?)? onChanged,
    String? hint,
    Color? hintTextColor,
  }) {
    return BlocProvider.value(
      // create: (context) => LandBloc(),
      value: _landBloc,
      child: BlocBuilder<LandBloc, LandState>(
        bloc: _landBloc,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Column(
                children: [
                  DropdownButtonHideUnderline(
                    child: Container(
                      width:
                          (kIsWeb) ? 150 : Constant.screenWidth(context) * 0.4,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1), color: containerColor),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: BlocProvider.value(
                          // create: (context) => LandBloc(),
                          value: _landBloc,
                          child: DropdownButton(
                            isExpanded: isExpanded,
                            dropdownColor: dropdownColor,
                            iconEnabledColor: iconEnabledColor,
                            hint: Text(
                              hint ?? "",
                              style:
                                  TextStyle(color: hintTextColor, fontSize: 12),
                            ),
                            value: value,
                            items: items,
                            //isExpanded: true,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            // onTap: () {

                            // },
                            onChanged: onChanged,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget customPdfButton(Function()? onTap, String buttonTitle, String counts) {
    return Container(
      height: 40,
      width: 60,
      decoration: BoxDecoration(
        color: CommonColors.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Material(
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: Text(
                    buttonTitle,
                    style: const TextStyle(
                      color: CommonColors.planeWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Count display in the top right corner
          Positioned(
            top: -8, // Move it up
            right: 0,
            // Move it right
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: CommonColors.secondary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  counts, // Your count value here
                  style: const TextStyle(
                    color: CommonColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget customCommonButton(
  //   Function()? onTap,
  //   String buttonTitle,
  // ) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Container(
  //       height: 40,
  //       width: 50,
  //       decoration: BoxDecoration(
  //         border: Border.all(width: 1, color: CommonColors.primary),
  //         borderRadius: const BorderRadius.all(
  //           Radius.circular(8),
  //         ),
  //       ),
  //       child: Center(
  //         child: Text(
  //           buttonTitle,
  //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
