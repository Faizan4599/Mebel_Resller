import 'package:flutter/material.dart';
import 'package:reseller_app/features/splash/ui/splash_ui.dart';

import 'helper/preference_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PreferenceUtils.init();
  runApp(SplashUi());
}
