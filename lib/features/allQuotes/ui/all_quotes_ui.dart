import 'package:flutter/material.dart';
import 'package:reseller_app/utils/common_colors.dart';

import '../../landscreen/model/get_all_quotes_data_model.dart';

class AllQuotesUI extends StatelessWidget {
  List<GetAllQuotesDataModel>? quotesList;
  AllQuotesUI({super.key, required this.quotesList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Quotes"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Table(
              border: const TableBorder(
                  bottom: BorderSide(),
                  horizontalInside: BorderSide(),
                  top: BorderSide(),
                  right: BorderSide(),
                  left: BorderSide()),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                    decoration: BoxDecoration(color: CommonColors.secondary),
                    children: [
                      Center(
                        child: Text(
                          'ID',
                          style: TextStyle(color: CommonColors.primary),
                        ),
                      ),
                      Center(
                        child: Text(
                          'NAME',
                          style: TextStyle(color: CommonColors.primary),
                        ),
                      ),
                      Center(
                        child: Text(
                          'DATE',
                          style: TextStyle(color: CommonColors.primary),
                        ),
                      ),
                      Center(
                        child: Text(
                          'PRICE',
                          style: TextStyle(color: CommonColors.primary),
                        ),
                      ),
                      // Center(
                      //   child: Text(
                      //     'VIEW ',
                      //     style: TextStyle(color: CommonColors.primary),
                      //   ),
                      // ),
                    ]),
                ...quotesList?.map(
                      (e) {
                        return TableRow(children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: 30,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: CommonColors.secondary,
                                        shape: BoxShape.rectangle,
                                        // color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)),
                                        border: Border.all(
                                            width: 1,
                                            color: CommonColors.primary)),
                                    child: Center(
                                        child: Text(
                                      "#${e.quote_id ?? ""}",
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold, color: CommonColors.primary),
                                    ))),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Center(
                              child: Text(e.cust_name ?? ""),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Center(
                              child: Text(e.quote_date ?? ""),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Center(
                              child: Text(e.quote_price ?? ""),
                            ),
                          ),
                          // TableCell(
                          //   verticalAlignment:
                          //       TableCellVerticalAlignment.middle,
                          //   child: Center(
                          //     child: Icon(
                          //       Icons.remove_red_eye,
                          //       size: 1,
                          //     ),
                          //   ),
                          // ),
                        ]);
                      },
                    ) ??
                    {}
              ],
            ),
          ),
        ),
      ),
    );
  }
}
