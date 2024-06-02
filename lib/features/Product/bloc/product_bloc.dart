import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/repo/api_repository.dart';
import 'package:reseller_app/repo/api_urls.dart';
import 'package:reseller_app/repo/response_handler.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  List<FailedCommonDataModel> addToCartList = <FailedCommonDataModel>[];
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
      ProductGotoAddToCartEvent event, Emitter<ProductState> emit) async {
    try {
      Map<String, String> gotoCartParameter = {
        "access_token1 ": Constant.access_token1,
        "access_token2 ": Constant.access_token2,
        "access_token3 ": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
        "product_id": event.product_id
      };
      var response = await APIRepository()
          .getCommonMethodAPI(gotoCartParameter, APIUrls.addToCart);
      if (response is Success) {
        if (response.response is List<FailedCommonDataModel>) {
          addToCartList = response.response as List<FailedCommonDataModel>;
        } else if (response.response is FailedCommonDataModel) {
          addToCartList.add(response.response as FailedCommonDataModel);
        }
        print("data check>>>>> ${addToCartList.first.message}");
        emit(ProductSuccessState(message: addToCartList.first.message ?? ""));
      } else if (response is Failed) {
        addToCartList = response.response as List<FailedCommonDataModel>;
        emit(ProductErrorState(message: addToCartList.first.message ?? ""));
      } else if (response is Failure) {
        emit(ProductErrorState(message: response.errorResponse.toString()));
      } else {
        emit(ProductErrorState(message: "An error occurred"));
      }
    } catch (e) {
      print("Catch err ${e.toString()}");
      emit(ProductErrorState(message: "Error occured ${e.toString()}"));
    }
    // emit(ProductNavigateToAddToCartState());
  }
}
