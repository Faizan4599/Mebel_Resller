import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/features/cart/model/get_cart_details_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];
  List<GetCartDetailsDataModel> getCartDetailsList =
      <GetCartDetailsDataModel>[];
  CartBloc() : super(CartInitial()) {
    on<GetDataEvent>(getDataEvent);
  }

  FutureOr<void> getDataEvent(GetDataEvent event, Emitter<CartState> emit) {
    try {
      
    } catch (e) {
      print("Catch Err ${e.toString()}");
    }
  }
}
