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
