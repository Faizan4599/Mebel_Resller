import 'dart:async';
import 'dart:io';
// import 'dart:typed8List';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:html' as html;
import 'package:reseller_app/features/getQuote/model/get_download_quote_data_model.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/utils/common_colors.dart';
import 'package:http/http.dart' as http;
part 'download_quote_event.dart';
part 'download_quote_state.dart';

class DownloadQuoteBloc extends Bloc<DownloadQuoteEvent, DownloadQuoteState> {
  DownloadQuoteBloc() : super(DownloadQuoteInitial()) {
    on<DownloadPdfEvent>(downloadPdfEvent);
  }
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

      for (var quoteData in data) {
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              List<pw.Widget> pageWidgets = [];

              // Add header part
              pageWidgets.addAll([
                pw.SizedBox(height: 5),
                pw.Container(
                  height: 50,
                  width: double.infinity,
                  decoration:
                      pw.BoxDecoration(color: CommonColors.pdfPrimaryColor),
                  child: pw.Row(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, right: 5),
                        child: pw.Text(
                          PreferenceUtils.getString(UserData.name.name),
                          style: pw.TextStyle(
                              color: CommonColors.pdfplaneWhiteColor,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Container(
                  width: double.infinity,
                  decoration:
                      pw.BoxDecoration(color: CommonColors.pdfPrimaryColor),
                  child: pw.Row(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, right: 5),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              child: pw.Text(
                                data.first.cust_name?.toUpperCase() ?? "",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: CommonColors.pdfplaneWhiteColor),
                                maxLines: 2,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.SizedBox(
                              width: 100 * 0.6,
                              child: pw.Text(
                                data.first.cust_address?.toUpperCase() ?? "",
                                style: pw.TextStyle(
                                    color: CommonColors.pdfplaneWhiteColor),
                                maxLines: 2,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.SizedBox(
                              width: 100 * 0.6,
                              child: pw.Row(
                                children: [
                                  pw.SizedBox(width: 5),
                                  pw.Text(
                                    data.first.cust_phone ?? "",
                                    style: pw.TextStyle(
                                        color: CommonColors.pdfplaneWhiteColor),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 20),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "DATE",
                            style: pw.TextStyle(
                                color: CommonColors.pdfplaneWhiteColor),
                          ),
                          pw.Text(
                            data.first.quote_date ?? "",
                            style: pw.TextStyle(
                                color: CommonColors.pdfplaneWhiteColor),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            "QUOTE ID",
                            style: pw.TextStyle(
                                color: CommonColors.pdfplaneWhiteColor),
                          ),
                          pw.Text(
                            data.first.quote_id ?? "",
                            style: pw.TextStyle(
                                color: CommonColors.pdfplaneWhiteColor),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            "AMOUNT DUE",
                            style: pw.TextStyle(
                                color: CommonColors.pdfplaneWhiteColor),
                          ),
                          pw.Row(
                            children: [
                              pw.Text(
                                data.first.quote_price ?? "",
                                style: pw.TextStyle(
                                    color: CommonColors.pdfplaneWhiteColor),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                pw.SizedBox(height: 5),
              ]);

              // Calculate the height of the header and other fixed content
              double fixedContentHeight = 120; // Adjust this value as needed
              double availableHeight =
                  PdfPageFormat.a4.availableHeight - fixedContentHeight;
              double rowHeight = 30; // Adjust the height of each row as needed

              // Calculate how many rows fit into the available height
              int rowsPerPage = (availableHeight / rowHeight).floor();

              // Add table header
              pageWidgets.add(
                pw.Container(
                  color: CommonColors.pdfSecondaryColor,
                  child: pw.Table(
                    border: const pw.TableBorder(
                      bottom: pw.BorderSide(),
                      horizontalInside: pw.BorderSide(),
                      top: pw.BorderSide(),
                      right: pw.BorderSide(),
                      left: pw.BorderSide(),
                    ),
                    children: [
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: CommonColors.pdfPrimaryColor,
                        ),
                        children: [
                          pw.Center(
                            child: pw.Text(
                              'ID',
                              style: pw.TextStyle(
                                color: CommonColors.pdfplaneWhiteColor,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Text(
                              'IMAGE',
                              style: pw.TextStyle(
                                color: CommonColors.pdfplaneWhiteColor,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Text(
                              'QTY',
                              style: pw.TextStyle(
                                color: CommonColors.pdfplaneWhiteColor,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Text(
                              'RATE',
                              style: pw.TextStyle(
                                color: CommonColors.pdfplaneWhiteColor,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Text(
                              'PRICE',
                              style: pw.TextStyle(
                                color: CommonColors.pdfplaneWhiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

              // Add table rows
              final tableRows = quoteData.quoteItems?.map(
                    (index) {
                      final imageBytes = imageBytesMap[index.product_url];
                      return pw.TableRow(children: [
                        pw.Center(child: pw.Text(index.quote_id ?? "")),
                        pw.Container(
                          width: 100,
                          height: 100,
                          child: imageBytes != null
                              ? pw.Align(
                                  alignment: pw.Alignment.center,
                                  child: pw.Image(pw.MemoryImage(imageBytes)),
                                )
                              : pw.Center(child: pw.Text('No image')),
                        ),
                        pw.Center(child: pw.Text("x ${index.qty ?? ""}")),
                        pw.Center(
                            child: pw.Text("\u{20B9}${index.price ?? ""}")),
                        pw.Center(
                            child: pw.Text(
                                "${int.parse(index.price ?? "0") * int.parse(index.qty ?? "0")}")),
                      ]);
                    },
                  )?.toList() ??
                  [];

              // Split the table rows into chunks that fit on a page dynamically
              for (int i = 0; i < tableRows.length; i += rowsPerPage) {
                final chunk = tableRows.skip(i).take(rowsPerPage).toList();
                pageWidgets.add(pw.Table(
                  border: const pw.TableBorder(
                      bottom: pw.BorderSide(),
                      horizontalInside: pw.BorderSide(),
                      top: pw.BorderSide(),
                      right: pw.BorderSide(),
                      left: pw.BorderSide()),
                  defaultVerticalAlignment:
                      pw.TableCellVerticalAlignment.middle,
                  children: chunk,
                ));
                if (i + rowsPerPage < tableRows.length) {
                  pageWidgets.add(pw.NewPage());
                }
              }

              // Add Terms and Conditions
              pageWidgets.add(
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          (quoteData.is_gst_quote == "0")
                              ? pw.Text(
                                  "Price is exclusive of GST.",
                                  style: pw.TextStyle(
                                      color: PdfColors.red,
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold),
                                )
                              : pw.Text(
                                  "Price is inclusive of GST.",
                                  style: pw.TextStyle(
                                      color: PdfColors.red,
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "TERM'S & CONDITION'S",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 8.0),
                        child: pw.Text(
                          quoteData.tnc ?? "",
                        ),
                      ),
                    ],
                  ),
                ),
              );

              return pageWidgets;
            },
          ),
        );
      }

      if (kIsWeb) {
        try {
          final bytes = await pdf.save();
          final blob = html.Blob([bytes], 'application/pdf');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute("download", "quote.pdf")
            ..click();
          return "Success";
        } catch (e) {
          print("ERROR AT PDF ${e.toString()}");
          return "";
        }
      } else {
        try {
          final dir = await getExternalStorageDirectory();
          final file = File("${dir!.path}/$fileName");
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
    try {
      final String custName =
          event.custname.isNotEmpty ? event.custname : "UnknownCustomer";
      final String quoteId =
          event.quoteid.isNotEmpty ? event.quoteid : "UnknownQuote";
      final String filename =
          "${custName.replaceAll(" ", "")}${quoteId.replaceAll(" ", "")}";

      emit(DownloadQuoteLoadingState());

      if (!kIsWeb && await storagePermission() || kIsWeb) {
        final imageBytesMap = await fetchImageBytes(event.data);
        final String filePath =
            await generatePdf(event.data, filename, imageBytesMap);
        print("FilePath ${filePath}");
        emit(DownloadQuoteSuccessState(filePath: filePath));
      } else {
        emit(
            DownloadQuoteErrorState(message: "Storage permission not granted"));
      }
    } catch (e) {
      emit(DownloadQuoteErrorState(message: "Error: ${e.toString()}"));
    }
  }
}
