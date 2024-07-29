part of 'all_quotes_bloc.dart';

@immutable
abstract class AllQuotesEvent {}

class AllQuotesNavigateToDownloadEvent extends AllQuotesEvent {
  List<GetDownloadQuoteDataModel>? data;
  AllQuotesNavigateToDownloadEvent({required this.data});
}

class AllQuotesFetchDataEvent extends AllQuotesEvent {
  String qId;
  AllQuotesFetchDataEvent({required this.qId});
}

class AllQuotesSearchEvent extends AllQuotesEvent {
  String? qId;
  String? cName;
  String? startDate;
  String? endDate;
  List<GetAllQuotesDataModel>? quotesList;
  AllQuotesSearchEvent(
      {this.qId, this.cName, this.startDate, this.endDate, this.quotesList});
}

class AllQuotesInitEvent extends AllQuotesEvent {
  List<GetAllQuotesDataModel>? quotesList;

  AllQuotesInitEvent({this.quotesList});
}

class AllQuotesResetTextEvent extends AllQuotesEvent {
  String? id;
  String? name;
  String? startdate;
  String? enddate;
  AllQuotesResetTextEvent({this.id, this.name, this.startdate, this.enddate});
}

class AllQuotesDropDownEvent extends AllQuotesEvent {
  bool value;
  AllQuotesDropDownEvent({required this.value});
}
