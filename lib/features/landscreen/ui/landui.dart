import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/landscreen/bloc/land_bloc.dart';
import 'package:reseller_app/features/login/ui/login_ui.dart';
import 'package:reseller_app/features/quote/ui/quote_ui.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/utils/common_colors.dart';
import 'package:open_file_plus/open_file_plus.dart';

class LandUi extends StatelessWidget {
  LandUi({Key? key}) : super(key: key) {
    _landBloc.add(LoadDataEvent());
    _landBloc
        .add(LandCategoryDropDownEvent(categoryDropDownValue: '', items: []));
  }
  final TextEditingController txt1 = TextEditingController();
  final TextEditingController txt2 = TextEditingController();
  final TextEditingController productId = TextEditingController();
  final LandBloc _landBloc = LandBloc();

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) {
    //     _landBloc.add(LoadDataEvent());
    //   },
    // );
    //  _landBloc.add(LoadDataEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Constant.appName,
          style: TextStyle(color: CommonColors.planeWhite),
        ),
        backgroundColor: CommonColors.primary,
        actions: [
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
                _showDownloadDialog(context, "logout");
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
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Center(
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
                          const Text(
                            "Filter",
                            style: TextStyle(
                                fontSize: 16, color: CommonColors.planeWhite),
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
                                  color:
                                      const Color.fromARGB(255, 255, 238, 238),
                                  _landBloc.show
                                      ? Icons.arrow_drop_down
                                      : Icons.arrow_drop_up,
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
            BlocBuilder<LandBloc, LandState>(
              bloc: _landBloc,
              builder: (context, state) {
                return BlocProvider.value(
                  value: _landBloc,
                  child: (_landBloc.show)
                      ? Container(
                          color: CommonColors.secondary,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
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
                                        value: _landBloc.sortDropdownValue == ''
                                            ? null
                                            : _landBloc.sortDropdownValue,
                                        items: _landBloc.sortItems
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          _landBloc.sortDropdownValue = value!;
                                          _landBloc.add(
                                            LandRegionDropDownEvent(
                                                sortingDropDownValue:
                                                    _landBloc.sortDropdownValue,
                                                items: _landBloc.sortItems),
                                          );
                                        }),
                                    customDropDownButton(
                                      title: "CATEGORY",
                                      context: context,
                                      isExpanded: true,
                                      value: _landBloc.colorDropdownValue == ''
                                          ? null
                                          : _landBloc.colorDropdownValue,
                                      items: _landBloc.categoryList
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item.category_name,
                                                child: Text(
                                                  item.category_name ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        _landBloc.colorDropdownValue = value!;
                                        _landBloc.add(LandCategoryDropDownEvent(
                                            categoryDropDownValue:
                                                _landBloc.colorDropdownValue,
                                            items: _landBloc.categoryList));
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
                                      context: context,
                                      isExpanded: true,
                                      value: _landBloc.styleDropdownValue == ''
                                          ? null
                                          : _landBloc.styleDropdownValue,
                                      items: _landBloc.styleItems
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        _landBloc.styleDropdownValue = value!;
                                        _landBloc.add(
                                            LandSubcategoryDropDownEvent(
                                                styleDropDownValue: _landBloc
                                                    .styleDropdownValue,
                                                items: _landBloc.styleItems));
                                      },
                                    ),
                                    customDropDownButton(
                                        context: context,
                                        isExpanded: true,
                                        items: _landBloc.materialItems
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      color: CommonColors
                                                          .planeWhite,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          _landBloc.materialDropdownValue =
                                              value!;
                                          _landBloc.add(
                                              LandSubcategory2DropDownEvent(
                                                  materialDropDownValue:
                                                      _landBloc
                                                          .materialDropdownValue,
                                                  items:
                                                      _landBloc.materialItems));
                                        },
                                        title: "SUBCATEGORY 2",
                                        value: _landBloc
                                                    .materialDropdownValue ==
                                                ''
                                            ? null
                                            : _landBloc.materialDropdownValue,
                                        containerColor: CommonColors.primary,
                                        dropdownColor: CommonColors.primary,
                                        iconEnabledColor:
                                            CommonColors.planeWhite,
                                        hintTextColor: CommonColors.planeWhite),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "PRODUCT ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: Constant.screenWidth(context) *
                                              0.4,
                                          child: TextField(
                                            cursorColor: CommonColors.primary,
                                            controller: productId,
                                            decoration: const InputDecoration(
                                                isDense: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          CommonColors.primary,
                                                      width: 2),
                                                ),
                                                hintText: "Enter product id",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.zero)),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                        const Text(
                                          "PRICE RANGE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        BlocProvider(
                                          create: (context) => LandBloc(),
                                          child: Text(
                                            "\$${_landBloc.start.toStringAsFixed(2)} - \$:${_landBloc.end.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
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
                                                _landBloc.start, _landBloc.end),
                                            labels: RangeLabels(
                                                _landBloc.start.toString(),
                                                _landBloc.end.toString()),
                                            onChanged: (value) {
                                              _landBloc.add(
                                                  LandPriceRangeSliderEvent(
                                                      start: _landBloc.start,
                                                      end: _landBloc.end));
                                            },
                                            onChangeStart: (value) {
                                              _landBloc.add(
                                                  LandPriceRangeSliderEvent(
                                                      start: value.start,
                                                      end: value.end));
                                            },
                                            onChangeEnd: (value) {
                                              _landBloc.add(
                                                  LandPriceRangeSliderEvent(
                                                      start: value.start,
                                                      end: value.end));
                                            },
                                            min: 10.0,
                                            max: 80.0,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                ButtonTheme(
                                  minWidth: 200,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        backgroundColor: CommonColors.primary),
                                    child: const Text(
                                      "SEARCH",
                                      style: TextStyle(
                                          color: CommonColors.planeWhite),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<LandBloc, LandState>(
                buildWhen: (previous, current) =>
                    current is LoadDataState ||
                    current is LandLoadMoreDataState,
                bloc: _landBloc,
                builder: (context, state) {
                  if (state is LoadDataState ||
                      state is LandLoadMoreDataState) {
                    var data = (state is LoadDataState)
                        ? state.data
                        : (state as LandLoadMoreDataState).data;
                    return RefreshIndicator(
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
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: CommonColors.primary),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(data[index].productId,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white)),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.share),
                                          iconSize: 20,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                data[index].productImage),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            "\$ ${data[index].productPrice}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ),
                                        BlocBuilder<LandBloc, LandState>(
                                          bloc: _landBloc,
                                          buildWhen: (previous, current) =>
                                              current is LandCheckboxState,
                                          builder: (context, state) {
                                            return Checkbox(
                                              side: WidgetStateBorderSide
                                                  .resolveWith(
                                                (states) => const BorderSide(
                                                    width: 1.0,
                                                    color: CommonColors
                                                        .planeWhite),
                                              ),
                                              focusColor:
                                                  CommonColors.planeWhite,
                                              checkColor: CommonColors.primary,
                                              activeColor:
                                                  CommonColors.planeWhite,
                                              value: _landBloc
                                                  .localData[index].isChecked,
                                              onChanged: (value) {
                                                _landBloc.add(
                                                  LandCheckboxEvent(
                                                      index: index,
                                                      isChecked: value!,
                                                      image: _landBloc
                                                          .localData[index]
                                                          .productImage,
                                                      data: _landBloc
                                                          .localData[index]),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Container(
          height: 50,
          decoration: const BoxDecoration(
            color: CommonColors.secondary,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // customPdfButton(() {}, "PDF", "0"),
                // customCommonButton(() {}, "PPT"),
                // customCommonButton(() {}, "XLS"),
                customCommonButton(() {
                  _landBloc.add(
                    LandDownloadImageEvent(data: _landBloc.selectedData),
                  );
                  _showDownloadDialog(context, "download");
                }, "IMAGE"),
                // IconButton(
                //     onPressed: () {},
                //     icon: Icon(
                //       Icons.file_download_outlined,
                //       size: 25,
                //     )),
                // InkWell(
                //   onTap: () {},
                //   child: const Icon(Icons.file_download_outlined),
                // ),
                const VerticalDivider(
                  // color: Colors.black,
                  thickness: 1,
                ),
                BlocListener<LandBloc, LandState>(
                  bloc: _landBloc,
                  listenWhen: (previous, current) =>
                      current is LandNavigateToQuoteState,
                  listener: (context, state) {
                    if (state is LandNavigateToQuoteState) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuoteUi(
                              perticularData: _landBloc.perticularData,
                            ),
                          ));
                    }
                  },
                  child: InkWell(
                    onTap: () {
                      _landBloc.add(LandNavigateToQuoteEvent());
                    },
                    child: Container(
                      height: 40,
                      width: 55,
                      decoration: const BoxDecoration(
                        color: CommonColors.primary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "QUOTE",
                          style: TextStyle(color: CommonColors.planeWhite),
                        ),
                      ),
                    ),
                  ),
                )
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
    Color? hintTextColor,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Column(
          children: [
            DropdownButtonHideUnderline(
              child: Container(
                width: Constant.screenWidth(context) * 0.4,
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
                        "Select criteria",
                        style: TextStyle(color: hintTextColor, fontSize: 14),
                      ),
                      value: value,
                      items: items,
                      //isExpanded: true,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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

  Widget customCommonButton(
    Function()? onTap,
    String buttonTitle,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: CommonColors.primary),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            buttonTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
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
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        (dialogType == "download")
                            ? "Do you want to download the images?"
                            : "Are you sure you want to logout?",
                        style: const TextStyle(fontSize: 15),
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
