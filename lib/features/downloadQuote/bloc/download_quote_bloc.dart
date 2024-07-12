import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui' show PlatformDispatcher;
import 'dart:html' as html;
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

part 'download_quote_event.dart';
part 'download_quote_state.dart';

class DownloadQuoteBloc extends Bloc<DownloadQuoteEvent, DownloadQuoteState> {
  DownloadQuoteBloc() : super(DownloadQuoteInitial()) {
    on<DownloadPdfEvent>(downloadPdfEvent);
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

Future<Uint8List> widgetToImageBytes(GlobalKey key) async {
  RenderRepaintBoundary boundary =
      key.currentContext?.findRenderObject() as RenderRepaintBoundary;

  double devicePixelRatio = PlatformDispatcher.instance.views.first.devicePixelRatio;

  if (kIsWeb) {
    // On web, adjust pixel ratio to a higher value for better resolution
    devicePixelRatio = 3.0; // Increase to improve resolution
  } else {
    // For mobile platforms, you can also set a higher pixel ratio if needed
    devicePixelRatio = 3.0; // Increase to improve resolution
  }
var transform = boundary.getTransformTo(null);
  print("matrix4[0]: ${transform.storage[0]}");
  print("matrix4[5]: ${transform.storage[5]}");
  print("Expected devicePixelRatio: $devicePixelRatio");

  if (transform.storage[0] != devicePixelRatio || transform.storage[5] != devicePixelRatio) {
    throw Exception('Matrix4 values do not match the expected devicePixelRatio');
  }

  // Ensure we use the correct pixel ratio when converting to image
  ui.Image image = await boundary.toImage(pixelRatio: devicePixelRatio);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}


Future<String> generatePdfFromWidget(
  Uint8List imageBytes,
  String fileName,
) async {
  final pdf = pw.Document();

  final image = pw.MemoryImage(imageBytes);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4, // You can adjust this to your needs
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image, fit: pw.BoxFit.contain),
        );
      },
    ),
  );

  if (kIsWeb) {
    // Web specific code to create a downloadable link
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "$fileName.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);
    return url; // returning URL for success state
  } else {
    final appFolder = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : Directory('/storage/emulated/0/Download/${Constant.appName}');
    if (!await appFolder.exists()) {
      await appFolder.create(recursive: true);
    }
    final file = File("${appFolder.path}/$fileName.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}


  Future<void> downloadPdfEvent(
      DownloadPdfEvent event, Emitter<DownloadQuoteState> emit) async {
    try {
      final String custName =
          event.custname.isNotEmpty ? event.custname : "UnknownCustomer";
      final String quoteId =
          event.quoteid.isNotEmpty ? event.quoteid : "UnknownQuote";
      final String filename =
          "${custName.replaceAll(" ", "")}${quoteId.replaceAll(" ", "")}";

      emit(DownloadQuoteLoadingState());
      try {
        if (!kIsWeb) {
          if (await storagePermission()) {
            GlobalKey globalKey = event.pdfkey;
            Uint8List imageBytes = await widgetToImageBytes(globalKey);

            final String filePath =
                await generatePdfFromWidget(imageBytes, filename);
            emit(DownloadQuoteSuccessState(filePath: filePath));
          } else {
            emit(DownloadQuoteErrorState(
                message: "Storage permission not granted"));
          }
        } else {
          GlobalKey globalKey = event.pdfkey;
          Uint8List imageBytes = await widgetToImageBytes(globalKey);

          final String filePath =
              await generatePdfFromWidget(imageBytes, filename);
          emit(DownloadQuoteSuccessState(filePath: filePath));
        }
      } catch (e) {
        print("Error during PDF generation: ${e.toString()}");
        emit(DownloadQuoteErrorState(message: "Error: ${e.toString()}"));
      }
    } catch (e) {
      print("Error in downloadPdfEvent: ${e.toString()}");
      emit(DownloadQuoteErrorState(message: "Error: ${e.toString()}"));
    }
  }
}
