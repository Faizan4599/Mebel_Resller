part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

abstract class SplashActionState extends SplashState {}

class SplashInitial extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashErrorState extends SplashState {}

class SplashSuccessState extends SplashState {}

class SplashNavigateToLandScreenState extends SplashActionState {}
