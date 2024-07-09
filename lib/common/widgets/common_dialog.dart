import 'package:flutter/material.dart';
import 'package:reseller_app/utils/common_colors.dart';

void showCommonDialog(
    {BuildContext? context,
    String? dialogTitle,
    String? dialogMessage,
    Function()? onCancel,
    Function()? onEvent,
    String? buttonTitle}) {
  showDialog(
    context: context!,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          // color: Colors.greenAccent,
          height: 145,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      dialogTitle ?? "",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 220,
                      child: Text(
                        dialogMessage ?? "",
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: CommonColors.primary,
                        ),
                        onPressed: onCancel,
                        child: const Text("Cancel")),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: CommonColors.primary,
                      ),
                      onPressed: onEvent,
                      child: Text(buttonTitle ?? ""),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
