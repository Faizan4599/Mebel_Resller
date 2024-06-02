import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/landscreen/model/get_categories_data_model.dart';
import 'package:reseller_app/features/landscreen/model/get_product_data_model.dart';
import 'package:reseller_app/features/landscreen/model/get_products_data_model.dart';
import 'package:reseller_app/features/landscreen/model/get_regions_data_model.dart';
import 'package:reseller_app/features/landscreen/model/get_sub_categories1.dart';
import 'package:reseller_app/features/landscreen/model/get_sub_categories2.dart';
import 'package:reseller_app/features/login/model/login_data_mode.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/repo/api_repository.dart';
import 'package:reseller_app/repo/api_urls.dart';
import 'package:reseller_app/repo/response_handler.dart';
import '../model/sample_data_model.dart';
part 'land_event.dart';
part 'land_state.dart';

class LandBloc extends Bloc<LandEvent, LandState> {
  List<GetCategoriesDataModel> categoryList = <GetCategoriesDataModel>[];
  List<GetSubCategories1DataModel> subCategoryList =
      <GetSubCategories1DataModel>[];
  List<GetSubCategories2DataModel> subCategory2List =
      <GetSubCategories2DataModel>[];
  List<GetProductDataModel> singleProductList = <GetProductDataModel>[];
  List<GetRegionsDataModel> regionList = <GetRegionsDataModel>[];
  List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];
  List<GetProductsDataModel> productsList = <GetProductsDataModel>[];
  bool show = false;
  List<String> selectedData = [];
  List<SampleDataModel> perticularData = [];
  int currentPage = 1;
  bool hasMoreData = true;
  final int itemsPerPage = 20;
  LandBloc() : super(LandInitial()) {
    on<LandDropdownEvent>(landDropdownEvent);
    on<LandSubcategoryDropDownEvent>(landSubcategoryDropDownEvent);
    on<LandSubcategory2DropDownEvent>(landSubcategory2DropDownEvent);
    on<LandRegionDropDownEvent>(landRegionDropDownEvent);
    on<LandCategoryDropDownEvent>(landCategoryDropDownEvent);
    on<LandPriceRangeSliderEvent>(landPriceRangeSliderEvent);
    on<LoadDataEvent>(loadDataEvent);
    on<LandCheckboxEvent>(landCheckboxEvent);
    on<LandDownloadImageEvent>(landDownloadImageEvent);
    on<LandNavigateToQuoteEvent>(landNavigateToQuoteEvent);
    on<LandLoadNextPageEvent>(landLoadNextPageEvent);
    on<LandRefreshDataEvent>(landRefreshDataEvent);
    on<LandLogoutEvent>(landLogoutEvent);
    on<LandSearchDataEvent>(landSearchDataEvent);
    on<LandClearDataEvent>(landClearDataEvent);
  }

  String sortDropdownValue = '';
  var sortItems = [
    'Best furniture stores',
    'Best discount',
    'Good quality',
    'Super',
    'Nice',
    'Trusted',
    'top',
    'good'
  ];

  String categoryVal = '';
  String subCategoryVal = '';
  String subCategory2Val = '';
  String regionVal = '';
  int start = 1000;
  int end = 100000;
  bool isChecked = false;
  List<SampleDataModel> localData = [];

  FutureOr<void> landDropdownEvent(
      LandDropdownEvent event, Emitter<LandState> emit) {
    show = !show;
    emit(LandDropDownState(value: event.value));
  }

  FutureOr<void> landSubcategoryDropDownEvent(
      LandSubcategoryDropDownEvent event, Emitter<LandState> emit) async {
    // emit(LandSubcategoryDropdownState(
    //     styleDropDownValue: event.styleDropDownValue, items: event.items));
    try {
      Map<String, String> subCatParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "category_id": event.category_id
      };
      var response = await APIRepository()
          .getCommonMethodAPI(subCatParameter, APIUrls.getSubcategories1);
      if (response is Success) {
        subCategoryVal = '';
        subCategoryList.clear();
        subCategory2Val = '';
        subCategory2List.clear();
        if (response.response is List<GetSubCategories1DataModel>) {
          subCategoryList =
              response.response as List<GetSubCategories1DataModel>;
        } else if (response.response is GetSubCategories1DataModel) {
          subCategoryList.add(response.response as GetSubCategories1DataModel);
        }
        // subCategoryVal = '';
        emit(
          LandSubcategoryDropdownState(
            subCategoryDropDownValue: event.subCategoryDropDownValue,
            items: event.items,
            category_id: event.category_id,
          ),
        );
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(LandErrorState(message: failedList.first.message.toString()));
      } else if (response is Failure) {
        emit(LandErrorState(message: response.errorResponse.toString()));
      } else {
        emit(LandErrorState(message: "An error occurred"));
      }
    } catch (e) {
      emit(LandErrorState(message: "Error occurred ${e.toString()}"));
    }
  }

  FutureOr<void> landSubcategory2DropDownEvent(
      LandSubcategory2DropDownEvent event, Emitter<LandState> emit) async {
    try {
      Map<String, String> subcategory2Parameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "subcategory1_id": event.subCategoryId
      };
      var response = await APIRepository()
          .getCommonMethodAPI(subcategory2Parameter, APIUrls.getSubcategories2);
      if (response is Success) {
        subCategory2Val = '';
        subCategory2List.clear();
        if (response.response is List<GetSubCategories2DataModel>) {
          subCategory2List =
              response.response as List<GetSubCategories2DataModel>;
        } else if (response.response is GetSubCategories2DataModel) {
          subCategory2List.add(response.response as GetSubCategories2DataModel);
        }

        emit(LandSubcategory2DropdownState(
            subcategoryDropDownValue: event.subcategory2DropDownValue,
            items: event.items));
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(LandErrorState(message: failedList.first.message.toString()));
      } else if (response is Failure) {
        emit(LandErrorState(message: response.errorResponse.toString()));
      } else {
        emit(LandErrorState(message: "An error occurred"));
      }
    } catch (e) {
      emit(LandErrorState(message: "Error occurred ${e.toString()}"));
    }
  }

  FutureOr<void> landRegionDropDownEvent(
      LandRegionDropDownEvent event, Emitter<LandState> emit) async {
    // emit(LandRegionDropdownState(
    //     regionValue: event.sortingDropDownValue, items: event.items));
    try {
      Map<String, String> regionParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
      };
      var response = await APIRepository()
          .getCommonMethodAPI(regionParameter, APIUrls.getRegions);
      if (response is Success) {
        regionList.clear();
        if (response.response is List<GetRegionsDataModel>) {
          regionList = response.response as List<GetRegionsDataModel>;
        } else if (response.response is GetRegionsDataModel) {
          regionList.add(response.response as GetRegionsDataModel);
        }

        emit(LandRegionDropdownState(
            regionValue: event.regionDropDownValue, items: event.items));
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(LandErrorState(message: failedList.first.message.toString()));
      } else if (response is Failure) {
        emit(LandErrorState(message: response.errorResponse.toString()));
      } else {
        emit(LandErrorState(message: "An error occurred"));
      }
    } catch (e) {
      emit(LandErrorState(message: "Error occurred ${e.toString()}"));
    }
  }

  FutureOr<void> landCategoryDropDownEvent(
      LandCategoryDropDownEvent event, Emitter<LandState> emit) async {
    try {
      Map<String, String> categoryParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
      };
      var response = await APIRepository()
          .getCommonMethodAPI(categoryParameter, APIUrls.getCategories);
      if (response is Success) {
        categoryVal = '';
        subCategoryVal = '';
        subCategory2Val = '';
        categoryList.clear();
        subCategoryList.clear();
        subCategory2List.clear();
        if (response.response is List<GetCategoriesDataModel>) {
          categoryList = response.response as List<GetCategoriesDataModel>;
        } else if (response.response is GetCategoriesDataModel) {
          categoryList.add(response.response as GetCategoriesDataModel);
        }
        emit(LandCategoryDropdownState(
            categoryValue: event.categoryDropDownValue, items: event.items));
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(LandErrorState(message: failedList.first.message.toString()));
      } else if (response is Failure) {
        emit(LandErrorState(message: response.errorResponse.toString()));
      } else {
        emit(LandErrorState(message: "An error occurred"));
      }
    } catch (e) {
      emit(LandErrorState(message: "Error occurred ${e.toString()}"));
    }
  }

  FutureOr<void> landPriceRangeSliderEvent(
      LandPriceRangeSliderEvent event, Emitter<LandState> emit) {
    start = event.start;
    end = event.end;
    emit(LandPriceRangeSliderState(start: start, end: end));
  }

  Future<FutureOr<void>> loadDataEvent(
      LoadDataEvent event, Emitter<LandState> emit) async {
    // final String response =
    //     await rootBundle.loadString('lib/localdatabase/data.json');
    // var data = await json.decode(response);
    // if (response.isEmpty) {
    //   emit(LandErrorState(message: "Failed to load data"));
    // } else if (data == null) {
    //   emit(LandErrorState(message: "No data!"));
    // } else if (data != null) {
    //   // emit(LandCheckboxState(isChecked: isChecked));
    //   localData = sampleDataModelFromJson(json.encode(data));
    //   print("DATA>>>> ${localData.first.productId}");
    //   emit(LoadDataState(data: localData));
    // }
    currentPage = 1;
    hasMoreData = true;
    await _fetchData(emit);
  }

  FutureOr<void> landCheckboxEvent(
      LandCheckboxEvent event, Emitter<LandState> emit) {
    isChecked = event.isChecked;
    localData[event.index].isChecked = event.isChecked;

    if (isChecked) {
      selectedData.add(event.image);
      perticularData.add(event.data);
    } else {
      perticularData.remove(event.data);
      selectedData.remove(event.image);
    }
    print("COUNT ${selectedData.map((e) => e)}");
    emit(
      LandCheckboxState(
          isChecked: isChecked,
          index: event.index,
          selectedImages: selectedData,
          perticularData: event.data),
    );
  }

  FutureOr<void> landDownloadImageEvent(
      LandDownloadImageEvent event, Emitter<LandState> emit) {
    event.data = selectedData;
    print("BLOC....${selectedData.map((e) => e)}");
    emit(LandDownloadImageState(imagesData: selectedData));
  }

  FutureOr<void> landNavigateToQuoteEvent(
      LandNavigateToQuoteEvent event, Emitter<LandState> emit) async {
    // emit(LandNavigateToQuoteState(productData: []));
    try {
      Map<String, String> productParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
        "product_id": event.productId.toString(),
      };
      var response = await APIRepository()
          .getCommonMethodAPI(productParameter, APIUrls.getProduct);
      print(">><><<>> ${response}");
      if (response is Success) {
        singleProductList.clear();
        if (response.response is List<GetProductDataModel>) {
          singleProductList = response.response as List<GetProductDataModel>;
        } else if (response.response is GetProductDataModel) {
          singleProductList.add(response.response as GetProductDataModel);
        }
        print("DATA>>> ${singleProductList.first.name}");
        emit(LandNavigateToQuoteState(productData: singleProductList));
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(LandErrorState(message: failedList.first.message.toString()));
      } else if (response is Failure) {
        emit(LandErrorState(message: response.errorResponse.toString()));
      } else {
        emit(LandErrorState(message: "An error occurred"));
      }
    } catch (e) {
      print("ERR ${e.toString()}");
      emit(LandErrorState(message: "Error occurred ${e.toString()}"));
    }
  }

  FutureOr<void> landLoadNextPageEvent(
      LandLoadNextPageEvent event, Emitter<LandState> emit) async {
    if (hasMoreData) {
      currentPage++;
      await _fetchData(emit, isLoadMore: true);
    }
  }

  FutureOr<void> landRefreshDataEvent(
      LandRefreshDataEvent event, Emitter<LandState> emit) async {
    productsList.clear();
    currentPage = 1;
    hasMoreData = true;
    await _fetchData(emit);
  }

  Future<List<GetProductsDataModel>> _fetchData(Emitter<LandState> emit,
      {bool isLoadMore = false}) async {
    try {
      Map<String, String> productsParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
      };
      var response2 = await APIRepository()
          .getCommonMethodAPI(productsParameter, APIUrls.getProducts);
      print(";;;;;;${response2}");
      if (response2 is Success) {
        productsList.clear();
        if (response2.response is List<GetProductsDataModel>) {
          productsList = response2.response as List<GetProductsDataModel>;
        } else if (response2 is GetProductsDataModel) {
          productsList.add(response2.response as GetProductsDataModel);
        }
        print(">>>>>>>>>>>>>>>>>>${productsList.first}");
        List<GetProductsDataModel> allData2 = [];
        allData2.addAll(productsList);
        List<GetProductsDataModel> paginatedData2 = allData2
            .skip((currentPage - 1) * itemsPerPage)
            .take(itemsPerPage)
            .toList();
        hasMoreData = paginatedData2.length == itemsPerPage;
        if (isLoadMore) {
          productsList.addAll(paginatedData2);
          emit(LandLoadMoreDataState(data: productsList));
        } else {
          productsList = paginatedData2;
          emit(LoadDataState(data: productsList));
        }
        return productsList;
      } else if (response2 is Failed) {
        failedList = response2.response as List<FailedCommonDataModel>;
        emit(LandErrorState(message: failedList.first.message.toString()));
        return [];
      } else if (response2 is Failure) {
        emit(LandErrorState(message: response2.errorResponse.toString()));
        return [];
      } else {
        emit(LandErrorState(message: "An error occurred"));
        return [];
      }
    } catch (e) {
      print("ERROR ${e.toString()}");
      emit(LandErrorState(message: "Error occurred ${e.toString()}"));
      return [];
    }
  }

  FutureOr<void> landLogoutEvent(
      LandLogoutEvent event, Emitter<LandState> emit) async {
    await PreferenceUtils.clearData();
    emit(LandLogoutState());
  }

  FutureOr<void> landSearchDataEvent(
      LandSearchDataEvent event, Emitter<LandState> emit) async {
    List<GetProductsDataModel> allData = await _fetchData(emit);

    List<GetProductsDataModel> filteredData = allData.where(
      (item) {
        int? itemPrice = item.price != null ? int.tryParse(item.price!) : null;
        bool matechesRange = itemPrice != null &&
            itemPrice >= event.startRange &&
            itemPrice <= event.endRange;
        bool matchesRegion =
            event.regionId == null || item.region_id == event.regionId;
        bool matechesCategory =
            event.categoryId == null || item.category_id == event.categoryId;
        bool matchSubCategory = event.subCategoryId == null ||
            item.subcategory1_id == event.subCategoryId;
        bool matchSubCategory2 = event.subCategory2Id == null ||
            item.subcategory2_id == event.subCategory2Id;
        bool matchesProduct =
            event.productId == null || item.product_id == event.productId;
        print("event.startRange ${event.startRange}");
        print("event.endRange ${event.endRange}");
        print("match matechesRange $matechesRange");
        return matechesRange &&
            matchesRegion &&
            matechesCategory &&
            matchSubCategory &&
            matchSubCategory2 &&
            matchesProduct;
      },
    ).toList();

    print(">>>Filter>>> ${filteredData.map(
      (e) => e.product_id,
    )}");
    emit(LandSearchDataState(filteredData: filteredData));
  }

  FutureOr<void> landClearDataEvent(
      LandClearDataEvent event, Emitter<LandState> emit) {
    event.value = '';
    event.list.clear();
    emit(LandClearDataState(value: event.value, list: event.list));
  }
}
