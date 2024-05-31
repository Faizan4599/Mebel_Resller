part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

sealed class ProductActionState extends ProductState {}

class ProductInitial extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductErrorState extends ProductState {}

class ProductSuccessState extends ProductState {}

class ProductSlideImageState extends ProductState {
  final int currentPage;
  ProductSlideImageState({required this.currentPage});
}

class ProductNavigateToAddToCartState extends ProductActionState {}
