import 'package:flutter/material.dart';
import 'package:reseller_app/common/widgets/pdf_format_widget.dart';
import 'package:reseller_app/utils/common_colors.dart';
import '../../getQuote/model/get_download_quote_data_model.dart';

class DownloadQuoteUI extends StatelessWidget {
  final List<GetDownloadQuoteDataModel>? data;
  DownloadQuoteUI({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: CommonColors.primary,
        child: Icon(
          Icons.download_outlined,
          size: 27,
          color: CommonColors.planeWhite,
        ),
        onPressed: () {},
      ),
      appBar: AppBar(
        title: const Text("Download Quote"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: pdfData(context: context, data: data),
        ),
      ),
    );
  }
}









    // Container(
    //           color: CommonColors.secondary,
    //           child: SingleChildScrollView(
    //             scrollDirection: Axis.horizontal,
    //             child: DataTable(
    //               dataRowMinHeight: 70,
    //               dataRowMaxHeight: 120,
    //               // columnSpacing: 10,
    //               columns: const <DataColumn>[
    //                 DataColumn(
    //                   label: Text('ID'),
    //                 ),
    //                 DataColumn(
    //                   label: Text('IMAGE'),
    //                 ),
    //                 DataColumn(
    //                   label: Text('RATE'),
    //                 ),
    //                 DataColumn(
    //                   label: Text('QTY'),
    //                 ),
    //               ],
    //               rows: List<DataRow>.generate(
    //                 data?.first.quoteItems?.length ?? 0,
    //                 (index) {
    //                   final listData = data?.first.quoteItems?[index];
    //                   return DataRow(cells: <DataCell>[
    //                     DataCell(
    //                       Text(listData?.product_id ?? ""),
    //                     ),
    //                     DataCell(
    //                       Container(
    //                         height: 100,
    //                         width: 100,
    //                         child: Image.network(
    //                           listData?.product_url ?? "",
    //                           fit: BoxFit.fill,
    //                           loadingBuilder: (BuildContext context,
    //                               Widget child,
    //                               ImageChunkEvent? loadingProgress) {
    //                             if (loadingProgress == null) return child;
    //                             return Center(
    //                               child: CircularProgressIndicator(
    //                                 value: loadingProgress.expectedTotalBytes !=
    //                                         null
    //                                     ? loadingProgress
    //                                             .cumulativeBytesLoaded /
    //                                         loadingProgress.expectedTotalBytes!
    //                                     : null,
    //                               ),
    //                             );
    //                           },
    //                         ),
    //                       ),
    //                     ),
    //                     DataCell(Text("\u{20B9}${listData?.price ?? ""}")),
    //                     DataCell(
    //                       Text(listData?.qty ?? ""),
    //                     ),
    //                   ]);
    //                 },
    //               ),
    //             ),
    //           ),
    //         ),