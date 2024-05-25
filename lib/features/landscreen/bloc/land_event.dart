part of 'land_bloc.dart';

@immutable
abstract class LandEvent {}

class LandDropdownEvent extends LandEvent {
  bool value;
  LandDropdownEvent({required this.value});
}

class LandSubcategoryDropDownEvent extends LandEvent {
  String styleDropDownValue;
  List<String> items;
  LandSubcategoryDropDownEvent(
      {required this.styleDropDownValue, required this.items});
}

class LandSubcategory2DropDownEvent extends LandEvent {
  String materialDropDownValue;
  List<String> items;
  LandSubcategory2DropDownEvent(
      {required this.materialDropDownValue, required this.items});
}

class LandRegionDropDownEvent extends LandEvent {
  String sortingDropDownValue;
  List<String> items;
  LandRegionDropDownEvent(
      {required this.sortingDropDownValue, required this.items});
}

class LandCategoryDropDownEvent extends LandEvent {
  String categoryDropDownValue;
  List<GetCategoriesDataModel> items;
  LandCategoryDropDownEvent(
      {required this.categoryDropDownValue, required this.items});
}

class LandPriceRangeSliderEvent extends LandEvent {
  double start;
  double end;
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

class LandNavigateToQuoteEvent extends LandEvent {}
