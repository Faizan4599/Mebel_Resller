part of 'land_bloc.dart';

@immutable
abstract class LandState {}

abstract class LandActionState {}

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
  String styleDropDownValue;
  List<String> items;
  LandSubcategoryDropdownState(
      {required this.styleDropDownValue, required this.items});
}

class LandSubcategory2DropdownState extends LandState {
  String materialDropDownValue;
  List<String> items;
  LandSubcategory2DropdownState(
      {required this.materialDropDownValue, required this.items});
}

class LandRegionDropdownState extends LandState {
  String sortingDropDownValue;
  List<String> items;
  LandRegionDropdownState(
      {required this.sortingDropDownValue, required this.items});
}

class LandCategoryDropdownState extends LandState {
  String categoryValue;
  List<GetCategoriesDataModel> items;
  LandCategoryDropdownState(
      {required this.categoryValue, required this.items});
}

class LandPriceRangeSliderState extends LandState {
  double start;
  double end;
  LandPriceRangeSliderState({required this.start, required this.end});
}

class LoadDataState extends LandState {
  List<SampleDataModel> data;
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
  List<SampleDataModel> data;
  LandLoadMoreDataState({required this.data});
}

class LandRefreshDataState extends LandState {
  List<SampleDataModel> data;
  LandRefreshDataState({required this.data});
}

class LandLogoutState extends LandState {}

class LandNavigateToQuoteState extends LandState {}
