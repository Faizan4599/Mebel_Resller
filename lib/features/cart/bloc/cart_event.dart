part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class GetDataEvent extends CartEvent {}

class CartAddCountEvent extends CartEvent {
  int count;
  CartAddCountEvent({required this.count});
}

class CartRemoveCountEvent extends CartEvent {
  int count;
  CartRemoveCountEvent({required this.count});
}

class CartDeleteSingleItem extends CartEvent {
  String productId;
  CartDeleteSingleItem({required this.productId});
}
