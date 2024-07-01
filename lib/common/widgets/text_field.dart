import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextfield(
    {String? title,
    TextStyle? titleStyle,
    TextStyle? txtStyle,
    double? txtHeight,
    double? txtWidth,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Color? cursorColor,
    TextEditingController? controller,
    InputBorder? focusedBorder,
    String? hintText,
    TextStyle? hintStyle,
    InputBorder? border,
    int? maxLines
    }) {
  return Column(
    // mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
   const   SizedBox(height: 5,),
      Text(
        title ?? "",
        style: titleStyle,
      ),
      SizedBox(
        height: txtHeight,
        width: txtWidth,
        child: TextField(
          style: txtStyle,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          cursorColor: cursorColor,
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
              // isDense: true,
              contentPadding: EdgeInsets.all(10),
              // contentPadding: edgein,
              focusedBorder: focusedBorder,
              hintText: hintText,
              hintStyle: hintStyle,
              border: border,
              ),
        ),
      ),
    ],
  );
}


