part of 'get_quote_bloc.dart';

@immutable
abstract class GetQuoteState {}

abstract class GetQuoteActionState extends GetQuoteState {}

final class GetQuoteInitial extends GetQuoteState {}

class GetQuoteErrorState extends GetQuoteState {
  String? message;
  GetQuoteErrorState({required this.message});
}

class GetQuoteTNCSuccessState extends GetQuoteState {
  String? tnc;
  GetQuoteTNCSuccessState({this.tnc});
}

class GetQuoteNavigateTo extends GetQuoteActionState {}

class GetQuoteCheckBoxState extends GetQuoteState {
  bool checkboxVal;
  GetQuoteCheckBoxState({required this.checkboxVal});
}
