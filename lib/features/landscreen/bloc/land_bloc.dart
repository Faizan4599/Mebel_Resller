import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/landscreen/model/get_categories_data_model.dart';
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
  List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];
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
  }

  String styleDropdownValue = '';
  var styleItems = [
    'Contemporary',
    'Scandinavian furniture style',
    'Minimalism',
    'Art Deco',
    'Industrial',
    'Rustic',
    'Traditional furniture style',
    'Mission style furniture'
  ];
  String materialDropdownValue = '';
  var materialItems = [
    'High',
    'Low',
    'Medium',
    'Low ',
    'Price high to low',
    'Price low to high',
  ];
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
  String colorDropdownValue = '';
  var colourItems = [
    'Red',
    'Blue',
    'Yellow',
    'Black',
    'Gold',
    'Brown',
    'Silver',
    'Green'
  ];

  double start = 30.0;
  double end = 50.0;
  bool isChecked = false;
  List<SampleDataModel> localData = [];

  FutureOr<void> landDropdownEvent(
      LandDropdownEvent event, Emitter<LandState> emit) {
    show = !show;
    emit(LandDropDownState(value: event.value));
  }

  FutureOr<void> landSubcategoryDropDownEvent(
      LandSubcategoryDropDownEvent event, Emitter<LandState> emit) {
    emit(LandSubcategoryDropdownState(
        styleDropDownValue: event.styleDropDownValue, items: event.items));
  }

  FutureOr<void> landSubcategory2DropDownEvent(
      LandSubcategory2DropDownEvent event, Emitter<LandState> emit) {
    emit(LandSubcategory2DropdownState(
        materialDropDownValue: event.materialDropDownValue,
        items: event.items));
  }

  FutureOr<void> landRegionDropDownEvent(
      LandRegionDropDownEvent event, Emitter<LandState> emit) {
    emit(LandRegionDropdownState(
        sortingDropDownValue: event.sortingDropDownValue, items: event.items));
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
        categoryList.clear();
        if (response.response is List<GetCategoriesDataModel>) {
          categoryList = response.response as List<GetCategoriesDataModel>;
        } else if (response.response is GetCategoriesDataModel) {
          categoryList.add(response.response as GetCategoriesDataModel);
        }
        emit(LandCategoryDropdownState(
            categoryValue: event.categoryDropDownValue, items: categoryList));
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
      LandNavigateToQuoteEvent event, Emitter<LandState> emit) {
    emit(LandNavigateToQuoteState());
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
    currentPage = 1;
    hasMoreData = true;
    await _fetchData(emit);
  }

  Future<void> _fetchData(Emitter<LandState> emit,
      {bool isLoadMore = false}) async {
    final String response =
        await rootBundle.loadString('lib/localdatabase/data.json');

    var data = await json.decode(response);

    if (response.isEmpty) {
      emit(LandErrorState(message: "Failed to load data"));
    } else if (data == null) {
      emit(LandErrorState(message: "No data!"));
    } else {
      List<SampleDataModel> allData =
          sampleDataModelFromJson(json.encode(data));
      List<SampleDataModel> paginatedData = allData
          .skip((currentPage - 1) * itemsPerPage)
          .take(itemsPerPage)
          .toList();

      hasMoreData = paginatedData.length == itemsPerPage;
      if (isLoadMore) {
        localData.addAll(paginatedData);
        emit(LandLoadMoreDataState(data: localData));
      } else {
        localData = paginatedData;
        emit(LoadDataState(data: localData));
      }
    }
  }

  FutureOr<void> landLogoutEvent(
      LandLogoutEvent event, Emitter<LandState> emit) async {
    await PreferenceUtils.clearData();
    emit(LandLogoutState());
  }
}
