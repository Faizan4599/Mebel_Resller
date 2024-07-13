import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reseller_app/features/splash/ui/splash_ui.dart';
import 'helper/preference_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await PreferenceUtils.init();

  final runableApp =
      _buildRunnableApp(isWeb: kIsWeb, webAppWidth: 480.0, app: SplashUi());
  runApp(runableApp);
  // runApp(SplashUi());
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }
  return Center(
    child: ClipRect(
      child: SizedBox(
        width: webAppWidth,
        child: app,
      ),
    ),
  );
}
