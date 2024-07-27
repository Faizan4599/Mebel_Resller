import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:reseller_app/common/failed_data_model.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/getQuote/model/get_download_quote_data_model.dart';
import 'package:reseller_app/features/landscreen/model/get_all_quotes_data_model.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/repo/api_repository.dart';
import 'package:reseller_app/repo/api_urls.dart';
import 'package:reseller_app/repo/response_handler.dart';

part 'all_quotes_event.dart';
part 'all_quotes_state.dart';

class AllQuotesBloc extends Bloc<AllQuotesEvent, AllQuotesState> {
  bool isAllQuotes = false;
  DateTime? _selectedDate;
  List<GetDownloadQuoteDataModel> dataList = <GetDownloadQuoteDataModel>[];
  List<GetAllQuotesDataModel> filteredQuoteList = <GetAllQuotesDataModel>[];
  List<FailedCommonDataModel> failedList = <FailedCommonDataModel>[];
  final TextEditingController quoteTXT = TextEditingController();
  final TextEditingController nameTXT = TextEditingController();
  final TextEditingController startDateTXT = TextEditingController();
  final TextEditingController endDateTXT = TextEditingController();

  AllQuotesBloc() : super(AllQuotesInitial()) {
    on<AllQuotesNavigateToDownloadEvent>(allQuotesNavigateToDownloadEvent);
    on<AllQuotesFetchDataEvent>(allQuotesFetchDataEvent);
    on<AllQuotesSearchEvent>(allQuotesSearchEvent);
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

  FutureOr<void> allQuotesSearchEvent(
      AllQuotesSearchEvent event, Emitter<AllQuotesState> emit) {
    emit(AllQuotesLoadingState(quoteId: ""));
    try {
      filteredQuoteList = event.quotesList!.where((quote) {
        final matchesQuoteId =
            event.qId == null || quote.quote_id!.contains(event.qId!);
        final matchesCustName =
            event.cName == null || quote.cust_name!.contains(event.cName!);

        DateTime? startDate;
        DateTime? endDate;
        DateTime? quoteCreatedAt;
        DateTime? quoteDate;

        try {
          if (event.startDate != null) {
            startDate = DateFormat('dd/MM/yyyy').parse(event.startDate!);
          }
          if (event.endDate != null) {
            endDate = DateFormat('dd/MM/yyyy').parse(event.endDate!);
          }
          quoteCreatedAt =
              DateFormat('dd/MM/yyyy').parse(quote.created_at.toString());
          quoteDate =
              DateFormat('dd/MM/yyyy').parse(quote.quote_date.toString());
        } catch (e) {
          print('Date parsing error: ${e.toString()}');
          return false;
        }

        final matchesStartDate = startDate == null ||
            (quoteCreatedAt != null && quoteCreatedAt.isAfter(startDate));
        final matchesEndDate = endDate == null ||
            (quoteDate != null && quoteDate.isBefore(endDate));

        return matchesQuoteId &&
            matchesCustName &&
            matchesStartDate &&
            matchesEndDate;
      }).toList();

      emit(AllQuotesSearchState(quotesList: filteredQuoteList));
    } catch (e) {
      emit(AllQuotesErrorState(message: "Error occurred ${e.toString()}"));
      print("Catch Err ${e.toString()}");
    }
  }

  selectStartDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      startDateTXT
        ..text = DateFormat('dd/MM/yyyy').format(_selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: startDateTXT.text.length, affinity: TextAffinity.upstream));
    }
  }

  selectEndDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      endDateTXT
        ..text = DateFormat('dd/MM/yyyy').format(_selectedDate!)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: endDateTXT.text.length, affinity: TextAffinity.upstream),
        );
    }
  }
}
