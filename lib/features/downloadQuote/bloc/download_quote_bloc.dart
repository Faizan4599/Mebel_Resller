import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:reseller_app/constant/constant.dart';
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

  Future<ui.Image> widgetToImage(GlobalKey key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 4.0);
    return image;
  }

  Future<Uint8List> imageToBytes(ui.Image image) async {
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
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ),
    );
    // final downloadsDirectory = await getExternalStorageDirectory();
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

  FutureOr<void> downloadPdfEvent(
      DownloadPdfEvent event, Emitter<DownloadQuoteState> emit) async {
    try {
      final filename = "${event.custname?.replaceAll(" ", "")}" +
          "${event.quoteid?.replaceAll(" ", "")}";
      // print("FILE NAME>>>>>>>${filename}");
      emit(DownloadQuoteLoadingState());
      if (await storagePermission()) {
        GlobalKey globalKey = event.pdfkey;
        ui.Image image = await widgetToImage(globalKey);
        Uint8List imageBytes = await imageToBytes(image);

        final filePath = await generatePdfFromWidget(imageBytes, filename);

        emit(DownloadQuoteSuccessState(filePath: filePath));
      } else {
        emit(
            DownloadQuoteErrorState(message: "Storage permission not granted"));
      }
    } catch (e) {
      print("Error ${e.toString()}");
      emit(DownloadQuoteErrorState(message: "Error!!! ${e.toString()}"));
    }
  }
}
