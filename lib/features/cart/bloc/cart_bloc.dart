import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/cart/model/cart_common_data_model.dart';
import 'package:reseller_app/features/cart/model/get_cart_details_model.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/repo/api_repository.dart';
import 'package:reseller_app/repo/api_urls.dart';
import 'package:reseller_app/repo/response_handler.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  DateTime? lastToastTime;
  List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];
  List<GetCartDetailsDataModel> getCartDetailsList =
      <GetCartDetailsDataModel>[];
  List<CartCommonDataModel> cartCommonDataList = <CartCommonDataModel>[];
  CartBloc() : super(CartInitial()) {
    on<GetDataEvent>(getDataEvent);
    on<CartAddCountEvent>(cartAddEvent);
    on<CartRemoveCountEvent>(cartRemoveEvent);
    on<CartDeleteSingleItem>(cartDeleteSingleItem);
    on<CartNavigateToLandScreenEvent>(cartNavigateToLandScreenEvent);
  }

  FutureOr<void> getDataEvent(
      GetDataEvent event, Emitter<CartState> emit) async {
    try {
      Map<String, String> getCartDataParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name)
      };
      var response = await APIRepository()
          .getCommonMethodAPI(getCartDataParameter, APIUrls.getCartDetails);
      print("Response ${response}");
      if (response is Success) {
        getCartDetailsList.clear();
        if (response.response is List<GetCartDetailsDataModel>) {
          getCartDetailsList =
              response.response as List<GetCartDetailsDataModel>;
        } else if (response.response is GetCartDetailsDataModel) {
          getCartDetailsList.add(response.response as GetCartDetailsDataModel);
        }
        emit(CartSuccessState(data: getCartDetailsList));
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(CartErrorState(message: failedList.first.message));
      } else if (response is Failure) {
        emit(CartErrorState(message: response.errorResponse.toString()));
      } else {
        emit(CartErrorState(message: "An error  occurred"));
      }
    } catch (e) {
      emit(CartErrorState(message: "Error occurred ${e.toString()}"));
      print("Catch Err ${e.toString()}");
    }
  }

  FutureOr<void> cartAddEvent(
      CartAddCountEvent event, Emitter<CartState> emit) async {
    try {
      final product = getCartDetailsList
          .firstWhere((element) => element.product_id == event.product_id);
      final updatedCount = int.parse(product.cart_qty.toString()) + 1;
      print("Add $updatedCount");
      // emit(CartAddCountState());
      Map<String, String> addCountParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
        "product_id": event.product_id,
        "qty": updatedCount.toString()
      };
      var response = await APIRepository()
          .getCommonMethodAPI(addCountParameter, APIUrls.getUpdateCart);
      print("Response ${response}");
      emit(CartLoadingState());
      if (response is Success) {
        cartCommonDataList.clear();
        if (response.response is List<CartCommonDataModel>) {
          cartCommonDataList = response.response as List<CartCommonDataModel>;
        } else if (response.response is CartCommonDataModel) {
          cartCommonDataList.add(response.response as CartCommonDataModel);
        }
        product.cart_qty = updatedCount.toString();
        print(cartCommonDataList.first.message);
        emit(CartSuccessState(
            data: getCartDetailsList,
            message: cartCommonDataList.first.message));

        emit(CartAddCountState(
            data: getCartDetailsList,
            message: cartCommonDataList.first.message));
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(CartErrorState(message: failedList.first.message));
      } else if (response is Failure) {
        emit(CartErrorState(message: response.errorResponse.toString()));
      } else {
        emit(CartErrorState(message: "An error  occurred"));
      }
    } catch (e) {
      emit(CartErrorState(message: "Error occurred ${e.toString()}"));
      print("Catch Err ${e.toString()}");
    }
  }

  FutureOr<void> cartRemoveEvent(
      CartRemoveCountEvent event, Emitter<CartState> emit) async {
    try {
      final product = getCartDetailsList
          .firstWhere((element) => element.product_id == event.product_id);
      final updatedCount = int.parse(product.cart_qty.toString()) - 1;
      print("remove $updatedCount");
      // emit(CartAddCountState());
      if (updatedCount < 1) {
        emit(CartErrorState(message: "Quantity cannot be less than 1"));
        return;
      }
      Map<String, String> removeCountParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
        "product_id": event.product_id,
        "qty": updatedCount.toString()
      };
      var response = await APIRepository()
          .getCommonMethodAPI(removeCountParameter, APIUrls.getUpdateCart);
      emit(CartLoadingState());
      print("Response ${response}");
      if (response is Success) {
        cartCommonDataList.clear();
        if (response.response is List<CartCommonDataModel>) {
          cartCommonDataList = response.response as List<CartCommonDataModel>;
        } else if (response.response is CartCommonDataModel) {
          cartCommonDataList.add(response.response as CartCommonDataModel);
        }
        product.cart_qty = updatedCount.toString();
        emit(CartSuccessState(
            data: getCartDetailsList,
            message: cartCommonDataList.first.message));
        emit(CartRemoveCountState(
            data: getCartDetailsList,
            message: cartCommonDataList.first.message));
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(CartErrorState(message: failedList.first.message));
      } else if (response is Failure) {
        emit(CartErrorState(message: response.errorResponse.toString()));
      } else {
        emit(CartErrorState(message: "An error  occurred"));
      }
    } catch (e) {
      emit(CartErrorState(message: "Error occurred ${e.toString()}"));
      print("Catch Err ${e.toString()}");
    }
  }

  FutureOr<void> cartDeleteSingleItem(
      CartDeleteSingleItem event, Emitter<CartState> emit) async {
    try {
      Map<String, String> deleteSingleItemParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
        "product_id": event.productId
      };
      var response = await APIRepository().getCommonMethodAPI(
          deleteSingleItemParameter, APIUrls.getRemoveFromCart);
      print("Response ${response}");
      if (response is Success) {
        cartCommonDataList.clear();
        if (response.response is List<CartCommonDataModel>) {
          cartCommonDataList = response.response as List<CartCommonDataModel>;
        } else if (response.response is CartCommonDataModel) {
          cartCommonDataList.add(response.response as CartCommonDataModel);
        }

        emit(CartDeleteSingleItemState(
            message: cartCommonDataList.first.message ?? "",
            description: cartCommonDataList.first.description));
        add(GetDataEvent());
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(CartErrorState(message: failedList.first.message));
      } else if (response is Failure) {
        emit(CartErrorState(message: response.errorResponse.toString()));
      } else {
        emit(CartErrorState(message: "An error  occurred"));
      }
    } catch (e) {
      emit(CartErrorState(message: "Error occurred ${e.toString()}"));
      print("Catch Err ${e.toString()}");
    }
  }

  FutureOr<void> cartNavigateToLandScreenEvent(
      CartNavigateToLandScreenEvent event, Emitter<CartState> emit) {
    emit(CartNavigateToLandScreenState());
  }
}
