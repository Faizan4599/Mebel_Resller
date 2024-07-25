import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/getQuote/model/get_download_quote_data_model.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/repo/api_repository.dart';
import 'package:reseller_app/repo/api_urls.dart';
import 'package:reseller_app/repo/response_handler.dart';

part 'all_quotes_event.dart';
part 'all_quotes_state.dart';

class AllQuotesBloc extends Bloc<AllQuotesEvent, AllQuotesState> {
  bool isAllQuotes = false;
  List<GetDownloadQuoteDataModel> dataList = <GetDownloadQuoteDataModel>[];
  List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];
  AllQuotesBloc() : super(AllQuotesInitial()) {
    on<AllQuotesNavigateToDownloadEvent>(allQuotesNavigateToDownloadEvent);
    on<AllQuotesFetchDataEvent>(allQuotesFetchDataEvent);
  }

  FutureOr<void> allQuotesNavigateToDownloadEvent(
      AllQuotesNavigateToDownloadEvent event, Emitter<AllQuotesState> emit) {}

  Future<FutureOr<void>> allQuotesFetchDataEvent(
      AllQuotesFetchDataEvent event, Emitter<AllQuotesState> emit) async {
    emit(AllQuotesLoadingState(quoteId: event.qId));
    try {
      Map<String, String> getQuoteParameter = {
        "access_token1": Constant.access_token1,
        "access_token2": Constant.access_token2,
        "access_token3": Constant.access_token3,
        "user_id": PreferenceUtils.getString(UserData.id.name),
        "quote_id": event.qId.toString(),
      };

      var response = await APIRepository()
          .getCommonMethodAPI(getQuoteParameter, APIUrls.getQuote);
      if (response is Success) {
        dataList.clear();
        if (response.response is List<GetDownloadQuoteDataModel>) {
          dataList = response.response as List<GetDownloadQuoteDataModel>;
        } else if (response.response is GetDownloadQuoteDataModel) {
          dataList.add(response.response as GetDownloadQuoteDataModel);
        }
        emit(AllQuotesDataState(dataList: dataList));
        // emit(AllQuotesNavigateToDownloadState());
      } else if (response is Failed) {
        failedList = response.response as List<FailedCommonDataModel>;
        emit(AllQuotesErrorState(message: failedList.first.message));
      } else if (response is Failure) {
        emit(AllQuotesErrorState(message: response.errorResponse.toString()));
      } else {
        emit(AllQuotesErrorState(message: "An error  occurred"));
      }
    } catch (e) {
      emit(AllQuotesErrorState(message: "Error occurred ${e.toString()}"));
      print("Catch Err ${e.toString()}");
    }
  }
}
