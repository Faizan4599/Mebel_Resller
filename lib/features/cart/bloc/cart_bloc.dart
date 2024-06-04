import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/cart/model/get_cart_details_model.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/repo/api_repository.dart';
import 'package:reseller_app/repo/api_urls.dart';
import 'package:reseller_app/repo/response_handler.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];
  List<GetCartDetailsDataModel> getCartDetailsList =
      <GetCartDetailsDataModel>[];
  CartBloc() : super(CartInitial()) {
    on<GetDataEvent>(getDataEvent);
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
}
