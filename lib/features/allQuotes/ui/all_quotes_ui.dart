import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/allQuotes/bloc/all_quotes_bloc.dart';
import 'package:reseller_app/features/downloadQuote/ui/download_quote_ui.dart';
import 'package:reseller_app/utils/common_colors.dart';

import '../../landscreen/model/get_all_quotes_data_model.dart';

class AllQuotesUI extends StatelessWidget {
  List<GetAllQuotesDataModel>? quotesList;
  AllQuotesUI({super.key, required this.quotesList});
  final AllQuotesBloc _allQuotesBloc = AllQuotesBloc();
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
            child: BlocListener<AllQuotesBloc, AllQuotesState>(
              bloc: _allQuotesBloc,
              listenWhen: (previous, current) => current is AllQuotesDataState,
              listener: (context, state) {
                if (state is AllQuotesDataState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DownloadQuoteUI(
                        data: state.dataList,
                      ),
                    ),
                  );
                }
              },
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
                            style: TextStyle(
                                color: CommonColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Center(
                          child: Text(
                            'NAME',
                            style: TextStyle(
                                color: CommonColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Center(
                          child: Text(
                            'DATE',
                            style: TextStyle(
                                color: CommonColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Center(
                          child: Text(
                            'PRICE',
                            style: TextStyle(
                                color: CommonColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
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
                                  child: InkWell(
                                    onTap: () async {
                                      // print("____________ ${e.quote_id}");
                                      _allQuotesBloc.add(
                                          AllQuotesFetchDataEvent(
                                              qId: e.quote_id.toString()));
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                          color: CommonColors.secondary,
                                          shape: BoxShape.rectangle,
                                          // color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14)),
                                          border: Border.all(
                                              width: 1,
                                              color: CommonColors.primary)),
                                      child: Center(
                                        child: BlocBuilder<AllQuotesBloc,
                                            AllQuotesState>(
                                          bloc: _allQuotesBloc,
                                          buildWhen: (previous, current) =>
                                              current
                                                  is AllQuotesLoadingState ||
                                              current is AllQuotesDataState ||
                                              current is AllQuotesErrorState,
                                          builder: (context, state) {
                                            if (state
                                                    is AllQuotesLoadingState &&
                                                state.quoteId == e.quote_id) {
                                              return Constant.spinKitLoader(
                                                  context,
                                                  CommonColors.primary);
                                            } else {
                                              return Text(
                                                "#${e.quote_id ?? ""}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        CommonColors.primary),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
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
      ),
    );
  }
}
