part of 'download_quote_bloc.dart';

@immutable
abstract class DownloadQuoteEvent {}

class DownloadPdfEvent extends DownloadQuoteEvent {
  final GlobalKey pdfkey;
 BuildContext? context;
 String? custname;
 String? quoteid;
  DownloadPdfEvent({required this.pdfkey, this.context, this.custname, this.quoteid});
}
