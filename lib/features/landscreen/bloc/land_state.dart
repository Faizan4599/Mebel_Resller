part of 'land_bloc.dart';

@immutable
abstract class LandState {}

abstract class LandActionState extends LandState {}

class LandInitial extends LandState {}

class LandLoadingState extends LandState {}

class LandErrorState extends LandState {
  String message;
  String? description;
  LandErrorState({required this.message, this.description});
}

class LandSuccesstate extends LandState {
  List<SampleDataModel> data;
  LandSuccesstate({required this.data});
}

class LandDropDownState extends LandState {
  bool value;
  LandDropDownState({required this.value});
}

class LandSubcategoryDropdownState extends LandState {
  String subCategoryDropDownValue;
  List<GetSubCategories1DataModel> items;
  String category_id;

  LandSubcategoryDropdownState(
      {required this.subCategoryDropDownValue,
      required this.category_id,
      required this.items});
}

class LandSubcategory2DropdownState extends LandState {
  String subcategoryDropDownValue;
  List<GetSubCategories2DataModel> items;
  LandSubcategory2DropdownState(
      {required this.subcategoryDropDownValue, required this.items});
}

class LandRegionDropdownState extends LandState {
  String regionValue;
  List<GetRegionsDataModel> items;
  LandRegionDropdownState({required this.regionValue, required this.items});
}

class LandCategoryDropdownState extends LandState {
  String categoryValue;
  List<GetCategoriesDataModel> items;
  LandCategoryDropdownState({required this.categoryValue, required this.items});
}

class LandStyleDropdownState extends LandState {
  String? style;
  List<GetStylesDataModel>? items;
  LandStyleDropdownState({this.style, this.items});
}

class LandPriceRangeSliderState extends LandState {
  int start;
  int end;
  LandPriceRangeSliderState({required this.start, required this.end});
}

class LoadDataState extends LandState {
  List<GetProductsDataModel> data;
  LoadDataState({required this.data});
}

class LandCheckboxState extends LandState {
  bool isChecked;
  int? index;
  List<String> selectedImages;
  SampleDataModel perticularData;
  LandCheckboxState(
      {required this.isChecked,
      this.index,
      required this.selectedImages,
      required this.perticularData});
}

class LandDownloadImageState extends LandState {
  List<String> imagesData;
  LandDownloadImageState({required this.imagesData});
}

class LandLoadMoreDataState extends LandState {
  List<GetProductsDataModel> data;
  LandLoadMoreDataState({required this.data});
}

class LandRefreshDataState extends LandState {
  List<GetProductsDataModel> data;
  LandRefreshDataState({required this.data});
}

class LandSearchDataState extends LandState {
  List<GetProductsDataModel> filteredData;
  LandSearchDataState({required this.filteredData});
}

class LandLogoutState extends LandState {}

class LandNavigateToQuoteState extends LandState {
  List<GetProductDataModel>? productData;
  LandNavigateToQuoteState({required this.productData});
}

class LandCartCountState extends LandState {
  List<GetCartCountDataModel>? data;
  LandCartCountState({required this.data});
}

class LandClearDataState extends LandState {
  String? value;
  List<dynamic> list;
  LandClearDataState({required this.value, required this.list});
}

class LandSearchDataNotFoundState extends LandState {
  String msg;
  LandSearchDataNotFoundState({required this.msg});
}

class LandNavigateToCartState extends LandActionState {}

class LandNavigateToAllQuotesState extends LandActionState {
  List<GetAllQuotesDataModel> quotesList;
  LandNavigateToAllQuotesState({required this.quotesList});
}

class LandNavigateToChangePasswordState extends LandActionState {}
