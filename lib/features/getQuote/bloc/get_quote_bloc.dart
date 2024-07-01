import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/constant/constant.dart';

import '../../../common/failed_data_model.dart';
import '../../../helper/preference_utils.dart';
import '../../../repo/api_repository.dart';
import '../../../repo/api_urls.dart';
import '../../../repo/response_handler.dart';
import '../model/get_tnc_data_model.dart';

part 'get_quote_event.dart';
part 'get_quote_state.dart';

class GetQuoteBloc extends Bloc<GetQuoteEvent, GetQuoteState> {
  List<GetTNCDataModel> tncDataList = <GetTNCDataModel>[];
  List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];
  GetQuoteBloc() : super(GetQuoteInitial()) {
    on<GetQuoteInitEvent>(getQuoteInitEvent);
    on<GetQuoteCheckBoxEvent>(getQuoteCheckBoxEvent);
  }

  FutureOr<void> getQuoteCheckBoxEvent(
      GetQuoteCheckBoxEvent event, Emitter<GetQuoteState> emit) {
    print("VALUE>>>>>>> ${event.checkboxVal}");
    emit(GetQuoteCheckBoxState(checkboxVal: event.checkboxVal));
  }

  Future<FutureOr<void>> getQuoteInitEvent(
      GetQuoteInitEvent event, Emitter<GetQuoteState> emit) async {
    try {
      Map<String, String> tncParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
      };
      var response = await APIRepository()
          .getCommonMethodAPI(tncParameter, APIUrls.getTnc);
      if (response is Success) {
        tncDataList.clear();
        if (response.response is List<GetTNCDataModel>) {
          tncDataList = response.response as List<GetTNCDataModel>;
        } else if (response.response is GetTNCDataModel) {
          tncDataList.add(response.response as GetTNCDataModel);
        }
        emit(GetQuoteTNCSuccessState(tnc: tncDataList.first.tnc));
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(GetQuoteErrorState(message: failedList.first.message));
      } else if (response is Failure) {
        emit(GetQuoteErrorState(message: response.errorResponse.toString()));
      } else {
        emit(GetQuoteErrorState(message: "An error  occurred"));
      }
    } catch (e) {
      emit(GetQuoteErrorState(message: "Error occurred ${e.toString()}"));
      print("Catch Err ${e.toString()}");
    }
  }
}
