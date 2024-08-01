part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordState {}

abstract class ChangePasswordActionState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoadingState extends ChangePasswordState {}

class ChangePasswordErrorState extends ChangePasswordState {}

class ChangePasswordSuccessState extends ChangePasswordState {}

class ChangePasswordNavigateToState extends ChangePasswordActionState {}
