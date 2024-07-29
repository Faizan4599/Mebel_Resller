part of 'all_quotes_bloc.dart';

@immutable
abstract class AllQuotesState {}

abstract class AllQuotesActionState extends AllQuotesState {}

final class AllQuotesInitial extends AllQuotesState {}

class AllQuotesLoadingState extends AllQuotesState {
  final String quoteId;
  AllQuotesLoadingState({required this.quoteId});
}

class AllQuotesErrorState extends AllQuotesState {
  String? message;
  AllQuotesErrorState({this.message});
}

class AllQuotesSuccessState extends AllQuotesState {}

class AllQuotesNavigateToDownloadState extends AllQuotesActionState {
  AllQuotesNavigateToDownloadState();
}

class AllQuotesDataState extends AllQuotesState {
  List<GetDownloadQuoteDataModel> dataList;
  AllQuotesDataState({required this.dataList});
}

class AllQuotesSearchState extends AllQuotesState {
  List<GetAllQuotesDataModel>? quotesList;
  AllQuotesSearchState({required this.quotesList});
}

class AllQuotesInitState extends AllQuotesState {
  List<GetAllQuotesDataModel>? quotesList;
  AllQuotesInitState({this.quotesList});
}

class AllQuotesResetTextState extends AllQuotesState {
  String? id;
  String? name;
  String? startdate;
  String? enddate;
  AllQuotesResetTextState({this.id, this.name, this.startdate, this.enddate});
}

class AllQuotesDropDownState extends AllQuotesState {
  bool value;
  AllQuotesDropDownState({required this.value});
}
