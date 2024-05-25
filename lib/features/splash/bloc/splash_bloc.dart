import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';


part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashInitNavigateEvent>(splashInitNavigateEvent);
  }

  FutureOr<void> splashInitNavigateEvent(
      SplashInitNavigateEvent event, Emitter<SplashState> emit) {
    emit(SplashInitial());
  }
}
