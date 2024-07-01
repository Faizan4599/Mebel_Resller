part of 'get_quote_bloc.dart';

@immutable
abstract class GetQuoteEvent {}

class GetQuoteInitEvent extends GetQuoteEvent {}

class GetQuoteCheckBoxEvent extends GetQuoteEvent {
  bool checkboxVal;
  GetQuoteCheckBoxEvent({required this.checkboxVal});
}
