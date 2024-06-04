import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reseller_app/utils/common_colors.dart';

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

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: Colors.transparent,
    ),
    textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: CommonColors.planeWhite,
        ),
        bodyMedium: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
    appBarTheme: const AppBarTheme(
      color: CommonColors.primary,
      titleTextStyle: TextStyle(
          color: CommonColors.planeWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );
}
