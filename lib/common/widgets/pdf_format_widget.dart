import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/getQuote/model/get_download_quote_data_model.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/utils/common_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// show this widget on download quote screen
Widget? pdfData(
    {required BuildContext? context,
    required List<GetDownloadQuoteDataModel>? data}) {
  if (data == null) {
    return const SizedBox();
  }
  return Column(
    children: [
      const SizedBox(
        height: 5,
      ),
      Container(
        height: 50,
        width: Constant.screenWidth(context!),
        decoration: const BoxDecoration(
          color: CommonColors.primary,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(
                PreferenceUtils.getString(UserData.name.name),
                style: const TextStyle(
                    color: CommonColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Container(
        width: Constant.screenWidth(context),
        decoration: const BoxDecoration(color: CommonColors.primary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (kIsWeb) ? 170 : Constant.screenWidth(context) * 0.3,
                    child: Text(
                      data?.first.cust_name?.toUpperCase() ?? "",
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: (kIsWeb) ? 170 : Constant.screenWidth(context) * 0.3,
                    child: Text(
                      data?.first.cust_address?.toUpperCase() ?? "",
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: Constant.screenWidth(context) * 0.3,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.call_outlined,
                          color: CommonColors.planeWhite,
                          size: 13,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          data?.first.cust_phone ?? "",
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DATE",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    data?.first.quote_date ?? "",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "QUOTE ID",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "#${data?.first.quote_id ?? ""}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "AMOUNT DUE",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Row(
                    children: [
                      Text(
                        "\u{20B9} ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        data?.first.quote_price ?? "",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        color: CommonColors.secondary,
        // padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Table(
              border: const TableBorder(
                  bottom: BorderSide(),
                  horizontalInside: BorderSide(),
                  top: BorderSide(),
                  right: BorderSide(),
                  left: BorderSide()),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                    decoration: BoxDecoration(color: CommonColors.primary),
                    children: [
                      Center(
                        child: Text(
                          'ID',
                          style: TextStyle(color: CommonColors.planeWhite),
                        ),
                      ),
                      Center(
                        child: Text(
                          'IMAGE',
                          style: TextStyle(color: CommonColors.planeWhite),
                        ),
                      ),
                      Center(
                        child: Text(
                          'QTY',
                          style: TextStyle(color: CommonColors.planeWhite),
                        ),
                      ),
                      Center(
                        child: Text(
                          'RATE',
                          style: TextStyle(color: CommonColors.planeWhite),
                        ),
                      ),
                      Center(
                        child: Text(
                          'PRICE',
                          style: TextStyle(color: CommonColors.planeWhite),
                        ),
                      ),
                    ]),
                ...data?.first.quoteItems?.map(
                      (index) {
                        return TableRow(children: [
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Center(child: Text("#${index.quote_id ?? ""}"))),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  index.product_url ?? "",
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      Text('Image not available'),
                                ),
                              ),
                            ),
                          ),
                          Center(child: Text("x ${index.qty ?? ""}")),
                          Center(child: Text("\u{20B9}${index.price ?? ""}")),
                          Center(
                              child: Text(
                                  "${int.parse(index.price ?? "0") * int.parse(index.qty ?? "0")}")),
                        ]);
                      },
                    ) ??
                    {},
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (data?.first.is_gst_quote == "0")
                          ? const Text(
                              "Price is exclusive of GST.",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              "Price is inclusive of GST.",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "TERM'S & CONDITION'S",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      data?.first.tnc ?? "",
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
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//this widget use for get pdf using pdf package
genratePDFPrintWidget(
    {required List<GetDownloadQuoteDataModel> data,
    required Map<String, Uint8List> imageBytesMap,
    required pw.Document pdf}) {
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
              decoration: pw.BoxDecoration(color: CommonColors.pdfPrimaryColor),
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
              decoration: pw.BoxDecoration(color: CommonColors.pdfPrimaryColor),
              child: pw.Padding(
                padding: pw.EdgeInsets.only(left: 10, right: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 170,
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
                          "#${data.first.quote_id ?? ""}",
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
            ),
            pw.SizedBox(height: 5),
          ]);

          // Calculate the height of the header and other fixed content
          double fixedContentHeight = 120; // Adjust this value as needed
          double availableHeight =
              PdfPageFormat.a4.availableHeight - fixedContentHeight;
          double rowHeight = 40; // Adjust the height of each row as needed

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
                      pw.Expanded(
                        child: pw.Text(
                          'ID',
                          style: pw.TextStyle(
                            color: CommonColors.pdfplaneWhiteColor,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          'IMAGE',
                          style: pw.TextStyle(
                            color: CommonColors.pdfplaneWhiteColor,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          'QTY',
                          style: pw.TextStyle(
                            color: CommonColors.pdfplaneWhiteColor,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          'RATE',
                          style: pw.TextStyle(
                            color: CommonColors.pdfplaneWhiteColor,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          'PRICE',
                          style: pw.TextStyle(
                            color: CommonColors.pdfplaneWhiteColor,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
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
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: CommonColors.pdfSecondaryColor,
                    ),
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          "#${index.quote_id ?? ""}",
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        child: imageBytes != null
                            ? pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Image(
                                  pw.MemoryImage(imageBytes),
                                  height: 100,
                                  width: 100,
                                  fit: pw.BoxFit.contain,
                                ))
                            : pw.SizedBox(),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          "x ${index.qty ?? ""}",
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          index.price ?? "",
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          "${int.parse(index.price ?? "0") * int.parse(index.qty ?? "0")}",
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ).toList() ??
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
                left: pw.BorderSide(),
              ),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
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
}
