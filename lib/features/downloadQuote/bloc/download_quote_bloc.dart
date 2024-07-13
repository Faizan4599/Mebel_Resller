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

  Future<String> generatePdf(
    List<GetDownloadQuoteDataModel> data,
    String fileName,
  ) async {
    try {
      final pdf = pw.Document();
      print("DDDDVVVVVVV${data.first.cust_name}");
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            final pageWidth = context.page.pageFormat.width;
            return pw.Column(
              children: data.map((quoteData) {
                return pw.Column(
                  children: [
                    pw.SizedBox(
                      height: 5,
                    ),
                    pw.Container(
                      height: 50,
                      width: pageWidth,
                      decoration: const pw.BoxDecoration(),
                      child: pw.Row(
                        children: [
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 5, right: 5),
                            child: pw.Text(
                              PreferenceUtils.getString(UserData.name.name),
                              style: pw.TextStyle(
                                  color: PdfColors.red,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    pw.Container(
                      width: 100,
                      decoration: const pw.BoxDecoration(color: PdfColors.red),
                      child: pw.Row(
                        children: [
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 5, right: 5),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: (kIsWeb) ? 170 : 100 * 0.6,
                                  child: pw.Text(
                                    data.first.cust_name?.toUpperCase() ?? "",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.red),
                                    // overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                pw.SizedBox(
                                  height: 5,
                                ),
                                pw.SizedBox(
                                  width: 100 * 0.6,
                                  child: pw.Text(
                                    data.first.cust_address?.toUpperCase() ?? "",
                                    style: pw.TextStyle(
                                        color: PdfColor.fromHex("FF233F24")),
                                    // overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                pw.SizedBox(
                                  height: 5,
                                ),
                                pw.SizedBox(
                                  width: 100 * 0.6,
                                  child: pw.Row(
                                    children: [
                                      // pw.Icon(
                                      //   Icons.call_outlined,
                                      //   color: PdfColor.fromHex("FFFFFFFF"),
                                      //   size: 13,
                                      // ),
                                      pw.SizedBox(
                                        width: 5,
                                      ),
                                      pw.Text(
                                        data.first.cust_phone ?? "",
                                        style: pw.TextStyle(
                                            color:
                                                PdfColor.fromHex("FFFFFFFF")),
                                        // overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(
                            width: 20,
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                "DATE",
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex("FFFFFFFF")),
                              ),
                              pw.Text(
                                data.first.quote_date ?? "",
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex("FFFFFFFF")),
                              ),
                              pw.SizedBox(
                                height: 6,
                              ),
                              pw.Text(
                                "QUOTE ID",
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex("FFFFFFFF")),
                              ),
                              pw.Text(
                                data.first.quote_id ?? "",
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex("FFFFFFFF")),
                              ),
                              pw.SizedBox(
                                height: 6,
                              ),
                              pw.Text(
                                "AMOUNT DUE",
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex("FFFFFFFF")),
                              ),
                              pw.Row(
                                children: [
                                  pw.Text(
                                    "\u{20B9} ",
                                    style: pw.TextStyle(
                                        color: PdfColor.fromHex("FFFFFFFF")),
                                  ),
                                  pw.Text(
                                    data.first.quote_price ?? "",
                                    style: pw.TextStyle(
                                        color: PdfColor.fromHex("FFFFFFFF")),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    pw.Container(
                      color: PdfColor.fromHex("FFFFF7D2"),
                      // padding: EdgeInsets.all(20.0),
                      child: pw.Column(
                        children: [
                          pw.Table(
                            border: const pw.TableBorder(
                                bottom: pw.BorderSide(),
                                horizontalInside: pw.BorderSide(),
                                top: pw.BorderSide(),
                                right: pw.BorderSide(),
                                left: pw.BorderSide()),
                            defaultVerticalAlignment:
                                pw.TableCellVerticalAlignment.middle,
                            children: [
                              pw.TableRow(
                                  decoration: pw.BoxDecoration(
                                      color: PdfColor.fromHex("FF233F24")),
                                  children: [
                                    pw.Center(
                                      child: pw.Text(
                                        'ID',
                                        style: pw.TextStyle(
                                            color:
                                                PdfColor.fromHex("FFFFFFFF")),
                                      ),
                                    ),
                                    pw.Center(
                                      child: pw.Text(
                                        'IMAGE',
                                        style: pw.TextStyle(
                                            color:
                                                PdfColor.fromHex("FFFFFFFF")),
                                      ),
                                    ),
                                    pw.Center(
                                      child: pw.Text(
                                        'QTY',
                                        style: pw.TextStyle(
                                            color:
                                                PdfColor.fromHex("FFFFFFFF")),
                                      ),
                                    ),
                                    pw.Center(
                                      child: pw.Text(
                                        'RATE',
                                        style: pw.TextStyle(
                                            color:
                                                PdfColor.fromHex("FFFFFFFF")),
                                      ),
                                    ),
                                    pw.Center(
                                      child: pw.Text(
                                        'PRICE',
                                        style: pw.TextStyle(
                                            color:
                                                PdfColor.fromHex("FFFFFFFF")),
                                      ),
                                    ),
                                  ]),
                              // ...data?.first.quoteItems?.map(
                              //       (index) {
                              //         return pw.TableRow(
                              //           children: [
                              //           pw.TableCell(
                              //               verticalAlignment:
                              //                   TableCellVerticalAlignment.middle,
                              //               child: Center(
                              //                   child:
                              //                       Text(index.quote_id ?? ""))),
                              //           TableCell(
                              //             verticalAlignment:
                              //                 TableCellVerticalAlignment.middle,
                              //             child: Padding(
                              //               padding: const EdgeInsets.only(
                              //                   top: 8.0, bottom: 8.0),
                              //               child: SizedBox(
                              //                 height: 100,
                              //                 width: 100,
                              //                 child: Image.network(
                              //                   index.product_url ?? "",
                              //                   fit: BoxFit.fill,
                              //                   loadingBuilder:
                              //                       (BuildContext context,
                              //                           Widget child,
                              //                           ImageChunkEvent?
                              //                               loadingProgress) {
                              //                     if (loadingProgress == null)
                              //                       return child;
                              //                     return Center(
                              //                       child:
                              //                           CircularProgressIndicator(
                              //                         value: loadingProgress
                              //                                     .expectedTotalBytes !=
                              //                                 null
                              //                             ? loadingProgress
                              //                                     .cumulativeBytesLoaded /
                              //                                 loadingProgress
                              //                                     .expectedTotalBytes!
                              //                             : null,
                              //                       ),
                              //                     );
                              //                   },
                              //                   errorBuilder: (context, error,
                              //                           stackTrace) =>
                              //                       Text('Image not available'),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //           Center(
                              //               child: Text("x ${index.qty ?? ""}")),
                              //           Center(
                              //               child: Text(
                              //                   "\u{20B9}${index.price ?? ""}")),
                              //           Center(
                              //               child: Text(
                              //                   "${int.parse(index.price ?? "0") * int.parse(index.qty ?? "0")}")),
                              //         ]);
                              //       },
                              //     ) ??
                              //     {},
                            ],
                          ),
                          pw.SizedBox(
                            height: 5,
                          ),
                          pw.Container(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
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
                                pw.SizedBox(
                                  height: 5,
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                    "TERM'S & CONDITION'S",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold),
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
                          )
                        ],
                      ),
                    )
                  ],
                );
              }).toList(),
            );
          },
        ),
      );

      if (kIsWeb) {
        try {
          final bytes = await pdf.save();
          final blob = html.Blob([bytes], 'application/pdf');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute("download", "$fileName.pdf")
            ..click();
          html.Url.revokeObjectUrl(url);
          return url;
        } catch (e) {
          print("kIsWeb ${e.toString()}");
          return "";
        }
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
        final String filePath = await generatePdf(event.data, filename);
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
