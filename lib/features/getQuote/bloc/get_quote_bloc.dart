import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:reseller_app/constant/constant.dart';
import '../../../common/failed_data_model.dart';
import '../../../helper/preference_utils.dart';
import '../../../repo/api_repository.dart';
import '../../../repo/api_urls.dart';
import '../../../repo/response_handler.dart';
import '../model/get_download_quote_data_model.dart';
import '../model/get_insert_quote_data_model.dart';
import '../model/get_tnc_data_model.dart';
part 'get_quote_event.dart';
part 'get_quote_state.dart';

class GetQuoteBloc extends Bloc<GetQuoteEvent, GetQuoteState> {
  List<GetTNCDataModel> tncDataList = <GetTNCDataModel>[];
  List<GetInsertQuoteDataModel> insertQuoteList = <GetInsertQuoteDataModel>[];
  List<GetDownloadQuoteDataModel> getQuoteList = <GetDownloadQuoteDataModel>[];
  List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];
  
  int? quote_id;
  GetQuoteBloc() : super(GetQuoteInitial()) {
    on<GetQuoteInitEvent>(getQuoteInitEvent);
    on<GetQuoteCheckBoxEvent>(getQuoteCheckBoxEvent);
    on<GetQuoteGenrateQuoteEvent>(getQuoteGenrateQuoteEvent);
    on<GetDownloadQuoteEvent>(getDownloadQuoteEvent);
  }
  // bool validateCredentials(String custName, String custAddress,
  //     String custPhone, String tnc, bool isGst) {
  //   if (custName.isEmpty) {
  //     return false;
  //   } else if (custAddress.isEmpty) {
  //     return false;
  //   } else if (custPhone.isEmpty || custPhone.length < 10) {
  //     return false;
  //   } else if (tnc.isEmpty) {
  //     return false;
  //   } else if (isGst == null) {
  //     return false;
  //   }
  //   return true;
  // }

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

  FutureOr<void> getQuoteGenrateQuoteEvent(
      GetQuoteGenrateQuoteEvent event, Emitter<GetQuoteState> emit) async {
    if (event.custName.isEmpty) {
      emit(GetQuoteValidationErrorState(message: "Please enter name."));
      return;
    }
    if (event.custAddress.isEmpty) {
      emit(GetQuoteValidationErrorState(message: "Please enter address."));
      return;
    }
    if (event.custPhone.isEmpty || event.custPhone.length < 10) {
      emit(GetQuoteValidationErrorState(
          message: "Phone number must be at least 10 digits."));
      return;
    }
    if (event.tnc.isEmpty) {
      emit(GetQuoteValidationErrorState(
          message: "Terms and conditions are required."));
      return;
    }

    try {
      Map<String, String> genrateQuoteParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
        "cust_name": event.custName,
        "cust_address": event.custAddress,
        "cust_phone": event.custPhone,
        "tnc": event.tnc,
        "is_gst_quote": (event.is_gst_quote == true) ? "1" : "0"
      };

      var response = await APIRepository()
          .getCommonMethodAPI(genrateQuoteParameter, APIUrls.insertQuoteData);
      if (response is Success) {
        insertQuoteList.clear();
        if (response.response is List<GetInsertQuoteDataModel>) {
          insertQuoteList = response.response as List<GetInsertQuoteDataModel>;
        } else if (response.response is GetInsertQuoteDataModel) {
          insertQuoteList.add(response.response as GetInsertQuoteDataModel);
        }
        // emit(GetQuoteTNCSuccessState(tnc: tncDataList.first.tnc));
        print(
            "CHECK QUOTE ID????????????????????${insertQuoteList.first.quote_id}");

        //quote_id variable use for download quote api as parameter.
        quote_id = insertQuoteList.first.quote_id ?? 0;
        emit(GetQuoteInsertQuotState(
            message: insertQuoteList.first.message.toString()));
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

  FutureOr<void> getDownloadQuoteEvent(
      GetDownloadQuoteEvent event, Emitter<GetQuoteState> emit) async {
    try {
      Map<String, String> getQuoteParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
        "quote_id": quote_id.toString(),
      };

      var response = await APIRepository()
          .getCommonMethodAPI(getQuoteParameter, APIUrls.getQuote);
      if (response is Success) {
        getQuoteList.clear();
        if (response.response is List<GetDownloadQuoteDataModel>) {
          getQuoteList = response.response as List<GetDownloadQuoteDataModel>;
        } else if (response.response is GetDownloadQuoteDataModel) {
          getQuoteList.add(response.response as GetDownloadQuoteDataModel);
        }
        // emit(GetQuoteTNCSuccessState(tnc: tncDataList.first.tnc));
        print(
            "CHECK QUOTE ID????????????????????${insertQuoteList.first.quote_id}");
        // emit(GetQuoteInsertQuotState(
        //     message: insertQuoteList.first.message.toString()));

        emit(GetQuoteDownloadState());
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
