part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class GetDataEvent extends CartEvent {}

class CartAddCountEvent extends CartEvent {
  String product_id;
  CartAddCountEvent({required this.product_id});
}

class CartRemoveCountEvent extends CartEvent {
  String product_id;
  CartRemoveCountEvent({required this.product_id});
}

class CartDeleteSingleItem extends CartEvent {
  String productId;
  CartDeleteSingleItem({required this.productId});
}

class CartNavigateToLandScreenEvent extends CartEvent {}
