import 'package:flutter/material.dart';

import '../../getQuote/model/get_download_quote_data_model.dart';

class DownloadQuoteUI extends StatelessWidget {
  List<GetDownloadQuoteDataModel>? data;
  DownloadQuoteUI({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download Quote"),
      ),
      body: Column(),
    );
  }
}
