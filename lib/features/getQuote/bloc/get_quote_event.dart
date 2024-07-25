part of 'get_quote_bloc.dart';

@immutable
abstract class GetQuoteEvent {}

class GetQuoteInitEvent extends GetQuoteEvent {}

class GetQuoteCheckBoxEvent extends GetQuoteEvent {
  bool checkboxVal;
  GetQuoteCheckBoxEvent({required this.checkboxVal});
}

class GetQuoteGenrateQuoteEvent extends GetQuoteEvent {
  String custName;
  String custAddress;
  String custPhone;
  String tnc;
  bool is_gst_quote;
  GetQuoteGenrateQuoteEvent(
      {required this.custName,
      required this.custAddress,
      required this.custPhone,
      required this.tnc,
      required this.is_gst_quote});
}

class GetDownloadQuoteEvent extends GetQuoteEvent {
 
  String? allQuotes;
  GetDownloadQuoteEvent({ this.allQuotes});
}
