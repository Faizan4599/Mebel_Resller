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

class CartNavigateTo extends CartActionState {}
