import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:reseller_app/common/widgets/pdf_format_widget.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/utils/common_colors.dart';
import 'package:share_plus/share_plus.dart';
import '../../../common/widgets/common_dialog.dart';
import '../../getQuote/model/get_download_quote_data_model.dart';
import '../bloc/download_quote_bloc.dart';

class DownloadQuoteUI extends StatelessWidget {
  final List<GetDownloadQuoteDataModel>? data;
  final GlobalKey globalKey = GlobalKey();
  final _downloadBloc = DownloadQuoteBloc();
  DownloadQuoteUI({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10,bottom: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: CommonColors.primary,
                child: const Icon(
                  Icons.download_outlined,
                  size: 27,
                  color: CommonColors.planeWhite,
                ),
                onPressed: () async {
                  final String custName = data?.first.cust_name ?? "";
                  final String quoteId = data?.first.quote_id ?? "";
                  _downloadBloc.add(
                    DownloadPdfEvent(
                        pdfkey: globalKey,
                        context: context,
                        custname: custName,
                        quoteid: quoteId,
                        data: data ?? []),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,bottom: 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: BlocListener<DownloadQuoteBloc, DownloadQuoteState>(
                bloc: _downloadBloc,
                listenWhen: (previous, current) =>
                    current is DownloadQuoteShareState,
                listener: (context, state) {
                  if (state is DownloadQuoteShareState) {
                    Share.shareXFiles([XFile(state.filePath)],
                        text: "Here is genrated quote file",
                        subject: "Quote file",);
                  }
                },
                child: FloatingActionButton(
                  backgroundColor: CommonColors.primary,
                  child: const Icon(
                    Icons.share_outlined,
                    size: 27,
                    color: CommonColors.planeWhite,
                  ),
                  onPressed: () async {
                    _downloadBloc.add(
                      DownloadShareEvent(
                        custname: data?.first.cust_name ?? "",
                        quoteid: data?.first.quote_id ?? "",
                        data: data ?? [],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text("Download Quote"),
      ),
      body: BlocListener<DownloadQuoteBloc, DownloadQuoteState>(
        bloc: _downloadBloc,
        listenWhen: (previous, current) =>
            current is DownloadQuoteSuccessState ||
            current is DownloadQuoteErrorState,
        listener: (context, state) {
          if (state is DownloadQuoteSuccessState) {
            showCommonDialog(
                dialogTitle: "PDF Generated",
                dialogMessage:
                    "The PDF has been generated. Do you want to open it?",
                buttonTitle: "Open",
                context: context,
                onCancel: () {
                  Navigator.pop(context);
                },
                onEvent: () {
                  OpenFilex.open(state.filePath);
                  Navigator.pop(context);
                });
          } else if (state is DownloadQuoteErrorState) {
            Constant.showShortToast(state.message);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: RepaintBoundary(
              key: globalKey,
              child: pdfData(context: context, data: data) ?? const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
