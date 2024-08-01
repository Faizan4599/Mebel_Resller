import 'package:flutter/material.dart';
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
              title: "OLD PASSWORD",
              titleStyle: Theme.of(context).textTheme.labelLarge,
              txtHeight: 45,
              txtWidth: Constant.screenWidth(context),
              txtStyle: Theme.of(context).textTheme.bodyMedium,
              cursorColor: CommonColors.primary,
              controller: _changePasswordBloc.oldPassTXT,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CommonColors.primary, width: 2),
              ),
              hintText: "Enter password",
              hintStyle: const TextStyle(fontSize: 13),
              border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            customTextfield(
              title: "NEW PASSWORD",
              titleStyle: Theme.of(context).textTheme.labelLarge,
              txtHeight: 45,
              txtWidth: Constant.screenWidth(context),
              txtStyle: Theme.of(context).textTheme.bodyMedium,
              cursorColor: CommonColors.primary,
              controller: _changePasswordBloc.oldPassTXT,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CommonColors.primary, width: 2),
              ),
              hintText: "Enter new password",
              hintStyle: const TextStyle(fontSize: 13),
              border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            customTextfield(
              title: "CONFIRM PASSWORD",
              titleStyle: Theme.of(context).textTheme.labelLarge,
              txtHeight: 45,
              txtWidth: Constant.screenWidth(context),
              txtStyle: Theme.of(context).textTheme.bodyMedium,
              cursorColor: CommonColors.primary,
              controller: _changePasswordBloc.oldPassTXT,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CommonColors.primary, width: 2),
              ),
              hintText: "Confirm password",
              hintStyle: const TextStyle(fontSize: 13),
              border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
           const SizedBox(height: 10,),
            ButtonTheme(
              minWidth: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
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
            )
          ],
        ),
      ),
    );
  }
}
