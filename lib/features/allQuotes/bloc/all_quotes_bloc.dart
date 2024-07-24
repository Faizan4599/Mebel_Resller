import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/features/getQuote/model/get_download_quote_data_model.dart';

part 'all_quotes_event.dart';
part 'all_quotes_state.dart';

class AllQuotesBloc extends Bloc<AllQuotesEvent, AllQuotesState> {
  bool isAllQuotes = false;
  AllQuotesBloc() : super(AllQuotesInitial()) {
    on<AllQuotesNavigateToDownloadEvent>(allQuotesNavigateToDownloadEvent);
  }

  FutureOr<void> allQuotesNavigateToDownloadEvent(
      AllQuotesNavigateToDownloadEvent event, Emitter<AllQuotesState> emit) {
        print("@@@@@@@@@@@@ ${event.isAllQuoteId}");
    emit(AllQuotesNavigateToDownloadState(
        isAllQuotes: event.isAllQuotes,
        isAllQuoteId: event.isAllQuoteId ?? "",
        dataList: event.dataList ?? []));
  }
}
