import 'package:flutter/material.dart';
import 'package:reseller_app/features/landscreen/ui/landui.dart';
import 'package:reseller_app/features/login/ui/login_ui.dart';
import 'package:reseller_app/features/splash/bloc/splash_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/helper/preference_utils.dart';

class SplashUi extends StatelessWidget {
  final SplashBloc _bloc = SplashBloc();
  SplashUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _bloc.add(SplashInitNavigateEvent());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.transparent,
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: BlocConsumer<SplashBloc, SplashState>(
            bloc: _bloc,
            buildWhen: (previous, current) => current is! SplashActionState,
            listenWhen: (previous, current) =>
                current is SplashActionState || current is SplashInitial,
            listener: (context, state) {
              if (state is SplashInitial) {
                print("SSSSS $state");
                print(
                    "SSSXXXX ${PreferenceUtils.getString(UserData.isLogin.name)}");
                Future.delayed(
                  Duration(seconds: 3),
                  () => (PreferenceUtils.getString(UserData.isLogin.name)
                              .parseBool() ==
                          true)
                      ? Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LandUi(),
                            // builder: (context) => LoginUi(),
                          ),
                        )
                      : Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            // builder: (context) => LandUi(),
                            builder: (context) => LoginUi(),
                          ),
                        ),
                );
                // Timer(
                //   Duration(
                //     seconds: 0,
                //   ),
                //   () => Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => SplashUi(),
                //     ),
                //   ),
                // );
              }
            },
            builder: (context, state) {
              return const Center(
                child: Text("Reseller App"),
              );
            },
          ),
        ),
      ),
    );
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
