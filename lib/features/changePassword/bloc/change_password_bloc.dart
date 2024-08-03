import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  TextEditingController oldPassTXT = TextEditingController();
  TextEditingController oldNewPassTXT = TextEditingController();
  TextEditingController oldConfirmPassTXT = TextEditingController();
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordButtonEvent>(changePasswordButtonEvent);
  }

  FutureOr<void> changePasswordButtonEvent(
      ChangePasswordButtonEvent event, Emitter<ChangePasswordState> emit) {
    print("PassWord is Changed");
  }

  bool passwordValidate(
      String password, String newPassword, String confirmPassword) {
    // bool pass = false;
    if (password.isEmpty) {
      emit(ChangePasswordErrorState(message: "Please enter current password"));
      return false;
    } else if (newPassword.isEmpty) {
      emit(ChangePasswordErrorState(message: "Please enter new password"));
      return false;
    } else if (confirmPassword.isEmpty) {
      emit(ChangePasswordErrorState(message: "Please enter confirm password"));
      return false;
    } else if (newPassword.length < 8) {
      emit(ChangePasswordErrorState(
          message:
              "New password is too short. It should be at least 8 characters."));
      return false;
    } else if (newPassword.length > 15) {
      emit(ChangePasswordErrorState(
          message:
              "New password is too long. It should be at most 15 characters."));
      return false;
    } else if (confirmPassword != newPassword) {
      emit(ChangePasswordErrorState(
          message: "Confirm password does not match the new password."));
      return false;
    }
    return true;
  }
}
