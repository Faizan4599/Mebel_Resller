import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'quote_event.dart';
part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  int currentPage = 0;
  QuoteBloc() : super(QuoteInitial()) {
    on<QuoteSlideImageEvent>(quoteSlideImageEvent);
    on<QuoteGotoAddToCartEvent>(quoteGotoAddToCartEvent);
  }

  FutureOr<void> quoteSlideImageEvent(
      QuoteSlideImageEvent event, Emitter<QuoteState> emit) {
    currentPage = event.currentPage;
    emit(QuoteSlideImageState(currentPage: currentPage));
  }

  FutureOr<void> quoteGotoAddToCartEvent(
      QuoteGotoAddToCartEvent event, Emitter<QuoteState> emit) {
    emit(QuoteNavigateToAddToCartState());
  }
}
