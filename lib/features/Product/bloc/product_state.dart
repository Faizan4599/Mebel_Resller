part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

sealed class ProductActionState extends ProductState {}

class ProductInitial extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductErrorState extends ProductState {
  String message;
  String? discription;
  ProductErrorState({required this.message, this.discription});
}

class ProductSuccessState extends ProductState {
  String message;
  String? discription;
  ProductSuccessState({required this.message, this.discription});
}

class ProductSlideImageState extends ProductState {
  final int currentPage;
  ProductSlideImageState({required this.currentPage});
}

class ProductNavigateToAddToCartState extends ProductActionState {}

class ProductNavigateToAddToLandScreenState extends ProductActionState {}
