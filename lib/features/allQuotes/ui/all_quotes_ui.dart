import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/common/widgets/text_field.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/allQuotes/bloc/all_quotes_bloc.dart';
import 'package:reseller_app/features/downloadQuote/ui/download_quote_ui.dart';
import 'package:reseller_app/utils/common_colors.dart';
import 'package:intl/intl.dart';
import '../../landscreen/model/get_all_quotes_data_model.dart';

class AllQuotesUI extends StatelessWidget {
  List<GetAllQuotesDataModel>? quotesList;
  AllQuotesUI({super.key, required this.quotesList});
  final AllQuotesBloc _allQuotesBloc = AllQuotesBloc();
  bool isDataType = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Quotes"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextfield(
                  title: "QUOTE ID",
                  titleStyle: Theme.of(context).textTheme.labelLarge,
                  txtHeight: 45,
                  txtWidth:
                      (kIsWeb) ? 150 : Constant.screenWidth(context) * 0.4,
                  txtStyle: Theme.of(context).textTheme.bodyMedium,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  cursorColor: CommonColors.primary,
                  controller: _allQuotesBloc.quoteTXT,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CommonColors.primary, width: 2),
                  ),
                  hintText: "Enter quote id",
                  hintStyle: TextStyle(fontSize: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                customTextfield(
                  title: "NAME",
                  titleStyle: Theme.of(context).textTheme.labelLarge,
                  txtHeight: 45,
                  txtWidth:
                      (kIsWeb) ? 150 : Constant.screenWidth(context) * 0.4,
                  txtStyle: Theme.of(context).textTheme.bodyMedium,
                  // keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  cursorColor: CommonColors.primary,
                  controller: _allQuotesBloc.nameTXT,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CommonColors.primary, width: 2),
                  ),
                  hintText: "Enter name",
                  hintStyle: TextStyle(fontSize: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextfield(
                  onTap: () {
                    _allQuotesBloc.selectStartDate(context);
                  },
                  readOnly: true,
                  title: "START DATE",
                  titleStyle: Theme.of(context).textTheme.labelLarge,
                  txtHeight: 45,
                  txtWidth:
                      (kIsWeb) ? 150 : Constant.screenWidth(context) * 0.4,
                  txtStyle: Theme.of(context).textTheme.bodyMedium,
                  keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  cursorColor: CommonColors.primary,
                  controller: _allQuotesBloc.startDateTXT,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CommonColors.primary, width: 2),
                  ),
                  hintText: "Enter start date",
                  hintStyle: TextStyle(fontSize: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                customTextfield(
                  onTap: () {
                    _allQuotesBloc.selectEndDate(context);
                  },
                  readOnly: true,
                  title: "END DATE",
                  titleStyle: Theme.of(context).textTheme.labelLarge,
                  txtHeight: 45,
                  txtWidth:
                      (kIsWeb) ? 150 : Constant.screenWidth(context) * 0.4,
                  txtStyle: Theme.of(context).textTheme.bodyMedium,
                  // keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  cursorColor: CommonColors.primary,
                  controller: _allQuotesBloc.endDateTXT,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CommonColors.primary, width: 2),
                  ),
                  hintText: "Enter end date",
                  hintStyle: TextStyle(fontSize: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ButtonTheme(
            minWidth: 200,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                _allQuotesBloc.add(AllQuotesSearchEvent(
                    qId: _allQuotesBloc.quoteTXT.text,
                    cName: _allQuotesBloc.nameTXT.text,
                    startDate: _allQuotesBloc.startDateTXT.text ?? "",
                    endDate: _allQuotesBloc.endDateTXT.text,
                    quotesList: quotesList ?? []));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                backgroundColor: CommonColors.primary,
              ),
              child: const Text(
                "SEARCH",
                style: TextStyle(color: CommonColors.planeWhite),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: BlocListener<AllQuotesBloc, AllQuotesState>(
                    bloc: _allQuotesBloc,
                    listenWhen: (previous, current) =>
                        current is AllQuotesDataState,
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
                    child: BlocBuilder<AllQuotesBloc, AllQuotesState>(
                      bloc: _allQuotesBloc,
                      buildWhen: (previous, current) =>
                          current is AllQuotesLoadingState ||
                          current is AllQuotesErrorState ||
                          current is AllQuotesDataState ||
                          current is AllQuotesSearchState,
                      builder: (context, state) {
                        if (state is AllQuotesLoadingState) {
                          return Constant.spinKitLoader(
                              context, CommonColors.primary);
                        } else if (state is AllQuotesErrorState) {
                          return Text("Error occurred! ${state.message}");
                        } else if (state is AllQuotesSearchState) {
                          return buildTable(state.quotesList);
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildTable(List<GetAllQuotesDataModel>? data) {
    return Table(
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
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            // print("____________ ${e.quote_id}");
                            _allQuotesBloc.add(AllQuotesFetchDataEvent(
                                qId: e.quote_id.toString()));
                          },
                          child: Container(
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: CommonColors.secondary,
                                shape: BoxShape.rectangle,
                                // color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                border: Border.all(
                                    width: 1, color: CommonColors.primary)),
                            child: Center(
                              child: BlocBuilder<AllQuotesBloc, AllQuotesState>(
                                bloc: _allQuotesBloc,
                                buildWhen: (previous, current) =>
                                    current is AllQuotesLoadingState ||
                                    current is AllQuotesDataState ||
                                    current is AllQuotesErrorState,
                                builder: (context, state) {
                                  if (state is AllQuotesLoadingState &&
                                      state.quoteId == e.quote_id) {
                                    return Constant.spinKitLoader(
                                        context, CommonColors.primary);
                                  } else {
                                    return Text(
                                      "#${e.quote_id ?? ""}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CommonColors.primary),
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
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Text(e.cust_name ?? ""),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Text(e.quote_date ?? ""),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
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
    );
  }
}
