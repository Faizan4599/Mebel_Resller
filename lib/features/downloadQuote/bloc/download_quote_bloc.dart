import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:reseller_app/common/widgets/pdf_format_widget.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:html' as html;
import 'package:reseller_app/features/getQuote/model/get_download_quote_data_model.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/utils/common_colors.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

part 'download_quote_event.dart';
part 'download_quote_state.dart';

class DownloadQuoteBloc extends Bloc<DownloadQuoteEvent, DownloadQuoteState> {
  DownloadQuoteBloc() : super(DownloadQuoteInitial()) {
    on<DownloadPdfEvent>(downloadPdfEvent);
    on<DownloadShareEvent>(downloadShareEvent);
  }
  bool isShare = false;
  Future<Map<String, Uint8List>> fetchImageBytes(
      List<GetDownloadQuoteDataModel> data) async {
    try {
      final Map<String, Uint8List> imageBytesMap = {};

      for (var quoteData in data) {
        for (var item in quoteData.quoteItems ?? []) {
          if (item.product_url != null && item.product_url!.isNotEmpty) {
            final response = await http.get(Uri.parse(item.product_url!));
            if (response.statusCode == 200) {
              imageBytesMap[item.product_url!] = response.bodyBytes;
            } else {
              throw Exception('Failed to load image from ${item.product_url}');
            }
          }
        }
      }

      return imageBytesMap;
    } catch (e) {
      print("ERROR ${e.toString()}");
      return {};
    }
  }

  Future<bool> storagePermission() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);

    bool havePermission = false;

    if (androidVersion >= 13) {
      final request = await [
        Permission.videos,
        Permission.photos,
      ].request();
      havePermission =
          request.values.every((status) => status == PermissionStatus.granted);
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      await openAppSettings();
    }
    return havePermission;
  }

  Future<String> generatePdf(
    List<GetDownloadQuoteDataModel> data,
    String fileName,
    Map<String, Uint8List> imageBytesMap,
  ) async {
    try {
      final pdf = pw.Document();
      await genratePDFPrintWidget(
          data: data, imageBytesMap: imageBytesMap, pdf: pdf);
      if (kIsWeb) {
        try {
          final bytes = await pdf.save();
          final blob = html.Blob([bytes], 'application/pdf');
          final url = html.Url.createObjectUrlFromBlob(blob);

          // Save the URL to the state for sharing
          return url;
          // return "";
        } catch (e) {
          print("ERROR IN DOWNLOADING FILE ${e.toString()}");
          return "";
        }
      } else {
        try {
          final dir = await getExternalStorageDirectory();
          final file = File("${dir!.path}/$fileName.pdf");
          await file.writeAsBytes(await pdf.save());
          return file.path;
        } catch (e) {
          print("ERROR AT PDF ${e.toString()}");
          return "";
        }
      }
    } catch (e) {
      print("ERROR AT PDF ${e.toString()}");
      return "";
    }
  }

  Future<void> downloadPdfEvent(
      DownloadPdfEvent event, Emitter<DownloadQuoteState> emit) async {
    emit(DownloadQuoteLoadingState());
    try {
      final String custName =
          event.custname.isNotEmpty ? event.custname : "UnknownCustomer";
      final String quoteId =
          event.quoteid.isNotEmpty ? event.quoteid : "UnknownQuote";
      final String filename =
          "Quote_${custName.replaceAll(" ", "")}_${quoteId.replaceAll(" ", "")}";

      if (!kIsWeb && await storagePermission() || kIsWeb) {
        final imageBytesMap = await fetchImageBytes(event.data);
        final String filePath =
            await generatePdf(event.data, filename, imageBytesMap);
        print("FilePath $filePath");

        if (kIsWeb) {
          try {
            final response = await http.get(Uri.parse(filePath));
            final blob = html.Blob([response.bodyBytes], 'application/pdf');
            final url = html.Url.createObjectUrlFromBlob(blob);
            final anchor = html.AnchorElement(href: url)
              ..setAttribute("download", "$filename.pdf")
              ..click();
            html.Url.revokeObjectUrl(url);
          } catch (e) {
            print("ERROR IN DOWNLOADING FILE ${e.toString()}");
          }
        }

        emit(DownloadQuoteSuccessState(filePath: filePath));
      } else {
        emit(
            DownloadQuoteErrorState(message: "Storage permission not granted"));
      }
    } catch (e) {
      emit(DownloadQuoteErrorState(message: "Error: ${e.toString()}"));
    }
  }

  FutureOr<void> downloadShareEvent(
      DownloadShareEvent event, Emitter<DownloadQuoteState> emit) async {
    // emit(DownloadQuoteLoadingState());
    emit(DownloadQuoteShareLoadingState());
    try {
      isShare = true;
      final filename =
          "Quote_${event.custname.replaceAll(" ", "")}_${event.quoteid.replaceAll(" ", "")}";
      if (!kIsWeb && await storagePermission() || kIsWeb) {
        final imageBytesMap = await fetchImageBytes(event.data);
        final String filePath =
            await generatePdf(event.data, filename, imageBytesMap);
        if (filePath.isNotEmpty) {
          emit(DownloadQuoteShareState(filePath: filePath, fileName: filename));
        }
      } else {
        emit(
            DownloadQuoteErrorState(message: "Storage permission not granted"));
      }
    } catch (e) {
      emit(DownloadQuoteErrorState(message: e.toString()));
    }
  }
}
