part of 'download_quote_bloc.dart';

@immutable
abstract class DownloadQuoteState {}

abstract class DownloadQuoteActionState extends DownloadQuoteState {}

class DownloadQuoteInitial extends DownloadQuoteState {}

class DownloadQuoteLoadingState extends DownloadQuoteState {}

class DownloadQuoteShareLoadingState extends DownloadQuoteState {}

class DownloadQuoteErrorState extends DownloadQuoteState {
  String message;
  DownloadQuoteErrorState({required this.message});
}

class DownloadQuoteSuccessState extends DownloadQuoteState {
  String filePath;
  DownloadQuoteSuccessState({required this.filePath});
}

class DownloadQuoteShareState extends DownloadQuoteState {
  String filePath;
  String fileName;
  DownloadQuoteShareState({required this.filePath, required this.fileName});
}

class DownloadPdfState extends DownloadQuoteState {}
