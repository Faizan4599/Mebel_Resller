part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class GetDataEvent extends CartEvent {}

class CartAddCountEvent extends CartEvent {
  int count;
  String product_id;
  CartAddCountEvent({required this.count, required this.product_id});
}

class CartRemoveCountEvent extends CartEvent {
  int count;
  String product_id;
  CartRemoveCountEvent({required this.count, required this.product_id});
}

class CartDeleteSingleItem extends CartEvent {
  String productId;
  CartDeleteSingleItem({required this.productId});
}
