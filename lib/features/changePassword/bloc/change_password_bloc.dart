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
      ChangePasswordButtonEvent event, Emitter<ChangePasswordState> emit) {}
}
