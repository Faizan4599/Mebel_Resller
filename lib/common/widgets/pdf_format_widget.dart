import 'package:flutter/material.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/getQuote/model/get_download_quote_data_model.dart';
import 'package:reseller_app/helper/preference_utils.dart';
import 'package:reseller_app/utils/common_colors.dart';

Widget pdfData({BuildContext? context, List<GetDownloadQuoteDataModel>? data}) {
  return Column(
    children: [
      const SizedBox(
        height: 5,
      ),
      (data?.first.is_gst_quote == "0")
          ? Text(
              "GST is not included in this quote.",
              style: TextStyle(
                  color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
            )
          : const SizedBox(),
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
        decoration: BoxDecoration(color: CommonColors.primary),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Constant.screenWidth(context) * 0.6,
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
                    width: Constant.screenWidth(context) * 0.6,
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
                    width: Constant.screenWidth(context) * 0.6,
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
            Column(
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
                  height: 5,
                ),
                Text(
                  "QUOTE ID",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  data?.first.quote_id ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
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
                    ]),
                ...data!.first.quoteItems!.map(
                  (index) {
                    return TableRow(children: [
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Center(child: Text(index.quote_id ?? ""))),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Center(child: Text("x ${index.qty ?? ""}")),
                      Center(child: Text("\u{20B9}${index.price ?? ""}")),
                    ]);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TERM'S & CONDITION'S",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
