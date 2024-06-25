import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/landscreen/ui/landui.dart';
import 'package:reseller_app/utils/common_colors.dart';
import '../bloc/login_bloc.dart';

class LoginUi extends StatelessWidget {
  LoginUi({Key? key}) : super(key: key);
  LoginBloc _loginBloc = LoginBloc();
  TextEditingController emailOrMobileTxt = TextEditingController();
  TextEditingController passTxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailOrMobileTxt.text = "test_merchant@gmail.com";
    passTxt.text = "admin";
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: 0.785, // Rotate by 45 degrees
                child: const Icon(
                  Icons.chair,
                  color: CommonColors.primary,
                  size: 45,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Text(
                  Constant.appName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: CommonColors.secondary,
              border: Border.all(color: CommonColors.primary, width: 2),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            width:kIsWeb?MediaQuery.of(context).size.width * 0.6: MediaQuery.of(context).size.width * 0.9,
            child: Column(
               // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: SizedBox(
                    // height: 50,
                    width: 300,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "Email/ Mobile number",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          cursorColor: CommonColors.primary,
                          controller: emailOrMobileTxt,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CommonColors.primary, width: 1)),
                              hintText: "email or mobile number",
                              border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: SizedBox(
                    // height: 50,
                    width: 300,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "Password",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        BlocBuilder<LoginBloc, LoginState>(
                          bloc: _loginBloc,
                          buildWhen: (previous, current) =>
                              current is LoginShowPasswordState,
                          builder: (context, state) {
                            return TextField(
                              style: Theme.of(context).textTheme.bodyMedium,
                              cursorColor: CommonColors.primary,
                              controller: passTxt,
                              obscureText: state is LoginShowPasswordState
                                  ? !state.showPass
                                  : true,
                              decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        print("SSs");
                                        _loginBloc.add(LoginShowPasswordEvent(
                                            showPass: !_loginBloc.showPass));
                                      },
                                      child: BlocBuilder<LoginBloc, LoginState>(
                                        bloc: _loginBloc,
                                        buildWhen: (previous, current) =>
                                            current is LoginShowPasswordState,
                                        builder: (context, state) {
                                          return Icon(
                                              (state is LoginShowPasswordState &&
                                                      _loginBloc.showPass)
                                                  ? Icons.visibility
                                                  : Icons.visibility_off);
                                        },
                                      )),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CommonColors.primary,
                                          width: 1)),
                                  hintText: "please enter password",
                                  border: const OutlineInputBorder()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                BlocProvider.value(
                  value: _loginBloc,
                  child: BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      print(">>>>>>>>>>>>>$state");
                      if (state is LoginSuccessState) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandUi(),
                          ),
                        );
                      } else if (state is LoginErrorState) {
                        Constant.showLongToast(state.message);
                      }
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CommonColors.primary,
                        shadowColor: CommonColors.primary,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minimumSize: const Size(180, 40), //////// HERE
                      ),
                      onPressed: () {
                        // if (emailOrMobileTxt.text == "asc" &&
                        //     passTxt.text == "123") {
                        //   _loginBloc.add(LoginOnTapEvent());
                        //   // Navigator.push(context, MaterialPageRoute(builder: (context) => LandUi(),));
                        // }
                        final isValid = _loginBloc.validateCredentials(
                          emailOrMobileTxt.text,
                          passTxt.text,
                        );
                        if (isValid) {
                          _loginBloc.add(LoginOnTapEvent(
                              username: emailOrMobileTxt.text,
                              password: passTxt.text));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => LandUi(),
                          //     ));
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: CommonColors.planeWhite),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
