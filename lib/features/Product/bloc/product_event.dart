part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class ProductSlideImageEvent extends ProductEvent {
  final int currentPage;
  ProductSlideImageEvent({required this.currentPage});
}

class ProductGotoAddToCartEvent extends ProductEvent {}
