part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  String message;
  String? description;
  LoginErrorState({required this.message, this.description});
}

class LoginSuccessState extends LoginState {
  List<LoginCommonDataModel> data;
  LoginSuccessState({required this.data});
}

class LoginShowPasswordState extends LoginState {
  bool showPass;
  LoginShowPasswordState({required this.showPass});
}

class LoginNavigateToState extends LoginActionState {}
