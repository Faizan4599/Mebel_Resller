part of 'get_quote_bloc.dart';

@immutable
sealed class GetQuoteState {}

sealed class GetQuoteActionState extends GetQuoteState {}

final class GetQuoteInitial extends GetQuoteState {}

class GetQuoteErrorState extends GetQuoteState {}

class GetQuoteSuccessState extends GetQuoteState {}

class GetQuoteNavigateTo extends GetQuoteActionState {}
