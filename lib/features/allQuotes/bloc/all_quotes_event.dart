part of 'all_quotes_bloc.dart';

@immutable
abstract class AllQuotesEvent {}

class AllQuotesNavigateToDownloadEvent extends AllQuotesEvent {
  bool? isAllQuotes;
  String? isAllQuoteId;
  List<GetDownloadQuoteDataModel>? dataList;
  AllQuotesNavigateToDownloadEvent(
      {required this.isAllQuotes,
      required this.isAllQuoteId,
      required this.dataList});
}
