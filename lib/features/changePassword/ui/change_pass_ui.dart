import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reseller_app/common/widgets/text_field.dart';
import 'package:reseller_app/constant/constant.dart';
import 'package:reseller_app/features/changePassword/bloc/change_password_bloc.dart';
import 'package:reseller_app/utils/common_colors.dart';

class ChangePasswordUI extends StatelessWidget {
  ChangePasswordUI({Key? key}) : super(key: key);
  ChangePasswordBloc _changePasswordBloc = ChangePasswordBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Column(
          children: [
            customTextfield(
              maxLines: 1,
              title: "CURRENT PASSWORD",
              titleStyle: Theme.of(context).textTheme.labelLarge,
              txtHeight: 45,
              txtWidth: Constant.screenWidth(context),
              txtStyle: Theme.of(context).textTheme.bodyMedium,
              cursorColor: CommonColors.primary,
              controller: _changePasswordBloc.oldPassTXT,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CommonColors.primary, width: 2),
              ),
              hintText: "Enter current password",
              hintStyle: const TextStyle(fontSize: 13),
              border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            customTextfield(
              maxLines: 1,
              title: "NEW PASSWORD",
              titleStyle: Theme.of(context).textTheme.labelLarge,
              txtHeight: 45,
              txtWidth: Constant.screenWidth(context),
              txtStyle: Theme.of(context).textTheme.bodyMedium,
              cursorColor: CommonColors.primary,
              controller: _changePasswordBloc.oldNewPassTXT,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CommonColors.primary, width: 2),
              ),
              hintText: "Enter new password",
              hintStyle: const TextStyle(fontSize: 13),
              border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            customTextfield(
              maxLines: 1,
              title: "CONFIRM PASSWORD",
              titleStyle: Theme.of(context).textTheme.labelLarge,
              txtHeight: 45,
              txtWidth: Constant.screenWidth(context),
              txtStyle: Theme.of(context).textTheme.bodyMedium,
              cursorColor: CommonColors.primary,
              controller: _changePasswordBloc.oldConfirmPassTXT,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CommonColors.primary, width: 2),
              ),
              hintText: "Confirm password",
              hintStyle: const TextStyle(fontSize: 13),
              border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            const SizedBox(
              height: 10,
            ),
            ButtonTheme(
              minWidth: 200,
              height: 40,
              child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
                bloc: _changePasswordBloc,
                listenWhen: (previous, current) =>
                    current is ChangePasswordErrorState ||
                    current is ChangePasswordSuccessState,
                listener: (context, state) {
                  if (state is ChangePasswordErrorState) {
                    Constant.showLongToast(state.message ?? "");
                  }
                },
                child: ElevatedButton(
                  onPressed: () {
                    final isValid = _changePasswordBloc.passwordValidate(
                        _changePasswordBloc.oldPassTXT.text,
                        _changePasswordBloc.oldNewPassTXT.text,
                        _changePasswordBloc.oldConfirmPassTXT.text);
                    if (isValid) {
                      _changePasswordBloc.add(ChangePasswordButtonEvent());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: CommonColors.primary,
                  ),
                  child: const Text(
                    "CHANGE PASSWORD",
                    style: TextStyle(color: CommonColors.planeWhite),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
