part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class ProductSlideImageEvent extends ProductEvent {
  final int currentPage;
  ProductSlideImageEvent({required this.currentPage});
}

class ProductGotoAddToCartEvent extends ProductEvent {
  String product_id;
  ProductGotoAddToCartEvent({required this.product_id});
}

class ProductNavigateToLandScreenEvent extends ProductEvent {}

class ProductNavigateToCartScreenEvent extends ProductEvent {}
