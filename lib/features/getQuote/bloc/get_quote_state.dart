part of 'get_quote_bloc.dart';

@immutable
abstract class GetQuoteState {}

abstract class GetQuoteActionState extends GetQuoteState {}

final class GetQuoteInitial extends GetQuoteState {}

class GetQuoteErrorState extends GetQuoteState {
  String? message;
  GetQuoteErrorState({required this.message});
}

class GetQuoteValidationErrorState extends GetQuoteState {
  String message;
  GetQuoteValidationErrorState({required this.message});
}

class GetQuoteTNCSuccessState extends GetQuoteState {
  String? tnc;
  GetQuoteTNCSuccessState({this.tnc});
}

class GetQuoteInsertQuotState extends GetQuoteState {
  String message;
  String? description;
  GetQuoteInsertQuotState({required this.message, this.description});
}

class GetQuoteCheckBoxState extends GetQuoteState {
  bool checkboxVal;
  GetQuoteCheckBoxState({required this.checkboxVal});
}
