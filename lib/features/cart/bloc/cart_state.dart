part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

sealed class CartActionState extends CartState {}

final class CartInitial extends CartState {}

class CartLoadingState extends CartState {}

class CartErrorState extends CartState {
  String? message;
  String? description;
  CartErrorState({required this.message, this.description});
}

class CartSuccessState extends CartState {
  List<GetCartDetailsDataModel>? data;
  String? message;
  CartSuccessState({required this.data, this.message});
}

class CartAddCountState extends CartState {
  List<GetCartDetailsDataModel>? data;
  String? message;
  CartAddCountState({this.data, this.message});
}

class CartRemoveCountState extends CartState {
  List<GetCartDetailsDataModel>? data;
  String? message;
  CartRemoveCountState({this.data, this.message});
}

class CartNavigateToLandScreenState extends CartActionState {}

class CartDeleteSingleItemState extends CartState {
  String message;
  String? description;
  CartDeleteSingleItemState({required this.message, this.description});
}


