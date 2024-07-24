part of 'all_quotes_bloc.dart';

@immutable
abstract class AllQuotesState {}

abstract class AllQuotesActionState extends AllQuotesState {}

final class AllQuotesInitial extends AllQuotesState {}

class AllQuotesLoadingState extends AllQuotesState {}

class AllQuotesErrorState extends AllQuotesState {}

class AllQuotesSuccessState extends AllQuotesState {}

class AllQuotesNavigateToDownloadState extends AllQuotesActionState {
  bool? isAllQuotes;
  String? isAllQuoteId;
  List<GetDownloadQuoteDataModel>? dataList;
  AllQuotesNavigateToDownloadState(
      {required this.isAllQuotes,
      required this.isAllQuoteId,
      required this.dataList});
}
