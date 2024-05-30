part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginOnTapEvent extends LoginEvent {
  String username;
  String password;
  LoginOnTapEvent({required this.username, required this.password});
}

class LoginShowPasswordEvent extends LoginEvent {
  bool showPass;
  LoginShowPasswordEvent({required this.showPass});
}
