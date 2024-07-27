import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:reseller_app/common/widgets/pdf_format_widget.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/utils/common_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_plus/share_plus.dart';
// import 'dart:html' as html;
import '../../../common/widgets/common_dialog.dart';
import '../../../helper/preference_utils.dart';
import '../../getQuote/model/get_download_quote_data_model.dart';
import '../bloc/download_quote_bloc.dart';

class DownloadQuoteUI extends StatelessWidget {
  final List<GetDownloadQuoteDataModel>? data;

  final GlobalKey globalKey = GlobalKey();
  final _downloadBloc = DownloadQuoteBloc();
  DownloadQuoteUI({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: BlocListener<DownloadQuoteBloc, DownloadQuoteState>(
                bloc: _downloadBloc,
                listenWhen: (previous, current) =>
                    current is DownloadQuoteSuccessState,
                listener: (context, state) {
                  if (state is DownloadQuoteSuccessState) {}
                },
                child: FloatingActionButton(
                  backgroundColor: CommonColors.primary,
                  child: BlocBuilder<DownloadQuoteBloc, DownloadQuoteState>(
                    bloc: _downloadBloc,
                    buildWhen: (previous, current) =>
                        current is DownloadQuoteLoadingState ||
                        current is DownloadQuoteSuccessState ||
                        current is DownloadQuoteErrorState,
                    builder: (context, state) {
                      if (state is DownloadQuoteLoadingState) {
                        return Constant.spinKitLoader(
                            context, CommonColors.planeWhite);
                      } else {
                        return const Icon(
                          Icons.download_outlined,
                          size: 27,
                          color: CommonColors.planeWhite,
                        );
                      }
                    },
                  ),
                  onPressed: () async {
                    if (data!.isNotEmpty && data != null) {
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
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: BlocListener<DownloadQuoteBloc, DownloadQuoteState>(
                bloc: _downloadBloc,
                listenWhen: (previous, current) =>
                    current is DownloadQuoteShareState,
                listener: (context, state) async {
                  if (state is DownloadQuoteShareState) {
                    if (kIsWeb) {
                      // try {
                      //   final response =
                      //       await html.window.fetch(state.filePath);
                      //   final blob = await response.blob();
                      //   final file = html.File(
                      //     [blob],
                      //     "${state.fileName.trim()}.pdf",
                      //     {"type": "application/pdf"},
                      //   );

                      //   // Ensure the navigator.share() is supported
                      //   if (html.window.navigator.share != null) {
                      //     try {
                      //       await html.window.navigator.share({
                      //         'title':
                      //             'Quote from ${PreferenceUtils.getString(UserData.name.name)}',
                      //         'text': 'Here is the generated quote file',
                      //         'files': [file],
                      //       });
                      //     } catch (error) {
                      //       print('Error sharing file: $error');
                      //     }
                      //   } else {
                      //     // Fallback for browsers that don't support Web Share API
                      //     html.AnchorElement anchor =
                      //         html.AnchorElement(href: state.filePath)
                      //           ..setAttribute(
                      //               "download", "${state.fileName.trim()}.pdf")
                      //           ..click();
                      //   }
                      // } catch (e) {
                      //   print("Error fetching file: $e");
                      // }
                    } else {
                      // Share the file path on mobile
                      Share.shareXFiles(
                        [XFile(state.filePath)],
                        text: "Here is the generated quote file",
                        subject: "Quote file",
                      );
                    }
                  }
                },
                child: FloatingActionButton(
                  backgroundColor: CommonColors.primary,
                  child: BlocBuilder<DownloadQuoteBloc, DownloadQuoteState>(
                    bloc: _downloadBloc,
                    buildWhen: (previous, current) =>
                        current is DownloadQuoteShareLoadingState ||
                        current is DownloadQuoteShareState ||
                        current is DownloadQuoteErrorState,
                    builder: (context, state) {
                      if (state is DownloadQuoteShareLoadingState) {
                        return Constant.spinKitLoader(
                            context, CommonColors.planeWhite);
                      } else {
                        return const Icon(
                          Icons.share_outlined,
                          size: 27,
                          color: CommonColors.planeWhite,
                        );
                      }
                    },
                  ),
                  onPressed: () async {
                    if (data!.isNotEmpty && data != null) {
                      _downloadBloc.add(
                        DownloadShareEvent(
                          custname: data?.first.cust_name ?? "",
                          quoteid: data?.first.quote_id ?? "",
                          data: data ?? [],
                        ),
                      );
                    }
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
            if (!kIsWeb) {
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
            }
          } else if (state is DownloadQuoteErrorState) {
            Constant.showShortToast(state.message);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: RepaintBoundary(
              key: globalKey,
              child: (data!.isNotEmpty && data != null)
                  ? pdfData(context: context, data: data)
                  : const Center(
                      child: Text("Data not available"),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
