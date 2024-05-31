import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  int currentPage = 0;
  ProductBloc() : super(ProductInitial()) {
    on<ProductSlideImageEvent>(productSlideImageEvent);
    on<ProductGotoAddToCartEvent>(productGotoAddToCartEvent);
  }

  FutureOr<void> productSlideImageEvent(
      ProductSlideImageEvent event, Emitter<ProductState> emit) {
    currentPage = event.currentPage;
    emit(ProductSlideImageState(currentPage: currentPage));
  }

  FutureOr<void> productGotoAddToCartEvent(
      ProductGotoAddToCartEvent event, Emitter<ProductState> emit) {
    emit(ProductNavigateToAddToCartState());
  }
}
