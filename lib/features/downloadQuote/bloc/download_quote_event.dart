part of 'download_quote_bloc.dart';

@immutable
abstract class DownloadQuoteEvent {}

class DownloadPdfEvent extends DownloadQuoteEvent {
  final GlobalKey pdfkey;
  final BuildContext context;
  final String custname;
  final String quoteid;
  final List<GetDownloadQuoteDataModel> data;

  DownloadPdfEvent({
    required this.pdfkey,
    required this.context,
    required this.custname,
    required this.quoteid,
    required this.data
  });
}
