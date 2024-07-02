part of 'land_bloc.dart';

@immutable
abstract class LandEvent {}

class LandDropdownEvent extends LandEvent {
  bool value;
  LandDropdownEvent({required this.value});
}

class LandSubcategoryDropDownEvent extends LandEvent {
  String subCategoryDropDownValue;
  List<GetSubCategories1DataModel> items;
  String category_id;
  LandSubcategoryDropDownEvent(
      {required this.subCategoryDropDownValue,
      required this.items,
      required this.category_id});
}

class LandSubcategory2DropDownEvent extends LandEvent {
  String subcategory2DropDownValue;
  String subCategoryId;
  List<GetSubCategories2DataModel> items;
  LandSubcategory2DropDownEvent(
      {required this.subcategory2DropDownValue,
      required this.subCategoryId,
      required this.items});
}

class LandRegionDropDownEvent extends LandEvent {
  String regionDropDownValue;
  List<GetRegionsDataModel> items;
  LandRegionDropDownEvent(
      {required this.regionDropDownValue, required this.items});
}

class LandCategoryDropDownEvent extends LandEvent {
  String categoryDropDownValue;
  List<GetCategoriesDataModel> items;
  LandCategoryDropDownEvent(
      {required this.categoryDropDownValue, required this.items});
}

class LandStyleDropDownEvent extends LandEvent {
  String? styleValue;
  List<GetStylesDataModel>? items;
  LandStyleDropDownEvent({this.styleValue, this.items});
}

class LandPriceRangeSliderEvent extends LandEvent {
  int start;
  int end;
  LandPriceRangeSliderEvent({required this.start, required this.end});
}

class LoadDataEvent extends LandEvent {}

class LandCheckboxEvent extends LandEvent {
  bool isChecked;
  int index;
  String image;
  SampleDataModel data;
  LandCheckboxEvent(
      {required this.isChecked,
      required this.index,
      required this.image,
      required this.data});
}

class LandDownloadImageEvent extends LandEvent {
  List<String> data;
  LandDownloadImageEvent({required this.data});
}

class LandLoadNextPageEvent extends LandEvent {}

class LandRefreshDataEvent extends LandEvent {}

class LandLogoutEvent extends LandEvent {}

class LandSearchDataEvent extends LandEvent {
  final int startRange;
  final int endRange;
  final String? regionId;
  final String? categoryId;
  final String? subCategoryId;
  final String? subCategory2Id;
  final String? productId;
  final String? styleId;

  LandSearchDataEvent(
      {required this.startRange,
      required this.endRange,
      this.regionId,
      this.categoryId,
      this.subCategoryId,
      this.subCategory2Id,
      this.productId,
      this.styleId});
}

class LandNavigateToQuoteEvent extends LandEvent {
  String? productId;
  LandNavigateToQuoteEvent({required this.productId});
}

class LandNavigateToCartEvent extends LandEvent {}

class LandCartCountEvent extends LandEvent {
  List<GetCartCountDataModel>? data;
  LandCartCountEvent({required this.data});
}

class LandClearDataEvent extends LandEvent {
  String value;
  List<dynamic> list;
  LandClearDataEvent({required this.value, required this.list});
}

class LandExitAppEvent extends LandEvent {
  DateTime? currentBackPressTime;
  bool canPopNow;
  int requiredSeconds;
  LandExitAppEvent(
      {this.currentBackPressTime,
      required this.canPopNow,
      required this.requiredSeconds});
}
