import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/Product/model/product_data_model.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/repo/api_repository.dart';
import 'package:reseller_app/repo/api_urls.dart';
import 'package:reseller_app/repo/response_handler.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  List<ProductDataModel> addToCartList = <ProductDataModel>[];
  List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];
  int currentPage = 0;
  ProductBloc() : super(ProductInitial()) {
    on<ProductSlideImageEvent>(productSlideImageEvent);
    on<ProductGotoAddToCartEvent>(productGotoAddToCartEvent);
    on<ProductNavigateToLandScreenEvent>(productNavigateToLandScreenEvent);
    on<ProductNavigateToCartScreenEvent>(productNavigateToCartScreenEvent);
  }

  FutureOr<void> productSlideImageEvent(
      ProductSlideImageEvent event, Emitter<ProductState> emit) {
    currentPage = event.currentPage;
    emit(ProductSlideImageState(currentPage: currentPage));
  }

  FutureOr<void> productGotoAddToCartEvent(
      ProductGotoAddToCartEvent event, Emitter<ProductState> emit) async {
    try {
      Map<String, String> addToCartParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
        "product_id": event.product_id
      };
      var response = await APIRepository()
          .getCommonMethodAPI(addToCartParameter, APIUrls.addToCart);
      if (response is Success) {
        addToCartList.clear();
        if (response.response is List<ProductDataModel>) {
          addToCartList = response.response as List<ProductDataModel>;
        } else if (response.response is ProductDataModel) {
          addToCartList.add(response.response as ProductDataModel);
        }
        emit(ProductSuccessState(
            message: addToCartList.first.message.toString()));
        emit(ProductNavigateToAddToCartState());
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(ProductErrorState(message: failedList.first.message.toString()));
      } else if (response is Failure) {
        emit(ProductErrorState(message: response.errorResponse.toString()));
      } else {
        emit(ProductErrorState(message: "An error occurred"));
      }
    } catch (e) {
      emit(ProductErrorState(message: "Error occurred ${e.toString()}"));
    }
  }

  FutureOr<void> productNavigateToLandScreenEvent(
      ProductNavigateToLandScreenEvent event, Emitter<ProductState> emit) {
    emit(ProductNavigateToAddToLandScreenState());
  }

  FutureOr<void> productNavigateToCartScreenEvent(
      ProductNavigateToCartScreenEvent event, Emitter<ProductState> emit) {
    emit(ProductNavigateToAddToCartState());
  }
}
