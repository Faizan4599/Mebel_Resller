part of 'all_quotes_bloc.dart';

@immutable
abstract class AllQuotesState {}

abstract class AllQuotesActionState extends AllQuotesState {}

final class AllQuotesInitial extends AllQuotesState {}

class AllQuotesLoadingState extends AllQuotesState {}

class AllQuotesErrorState extends AllQuotesState {}

class AllQuotesSuccessState extends AllQuotesState {}

class AllQuotesNavigateToState extends AllQuotesActionState {}
