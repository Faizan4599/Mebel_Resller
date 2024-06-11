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
  CartSuccessState({required this.data});
}

class CartAddCountState extends CartState {
  int count;
  CartAddCountState({required this.count});
}

class CartRemoveCountState extends CartState {
  int count;
  CartRemoveCountState({required this.count});
}

class CartNavigateTo extends CartActionState {}

class CartDeleteSingleItemState extends CartState {
  String message;
  String? description;
  CartDeleteSingleItemState({required this.message, this.description});
}
