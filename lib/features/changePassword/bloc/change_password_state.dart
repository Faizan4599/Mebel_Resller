part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordState {}

abstract class ChangePasswordActionState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoadingState extends ChangePasswordState {}

class ChangePasswordErrorState extends ChangePasswordState {
  String? message;
  ChangePasswordErrorState({required this.message});
}

class ChangePasswordSuccessState extends ChangePasswordState {}

class ChangePasswordNavigateToState extends ChangePasswordActionState {}
