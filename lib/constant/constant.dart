import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constant {
  static const String appName = "Luxury Furniture";
  static const String testMainBaseUrl = "https://test-furniture.shop/api/";
  static const String access_token1 = "v0beiriGG7bfk1V";
  static const String access_token2 = "CA1qVpqaHp1d6q0";
  static const String access_token3 = "llIs1UjMlacR4iF";

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static void showLongToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void showShortToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
