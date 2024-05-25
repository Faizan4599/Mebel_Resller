part of 'quote_bloc.dart';

@immutable
sealed class QuoteState {}

sealed class QuoteActionState extends QuoteState {}

class QuoteInitial extends QuoteState {}

class QuoteLoadingState extends QuoteState {}

class QuoteErrorState extends QuoteState {}

class QuoteSuccessState extends QuoteState {}

class QuoteSlideImageState extends QuoteState {
  final int currentPage;
  QuoteSlideImageState({required this.currentPage});
}

class QuoteNavigateToAddToCartState extends QuoteActionState {}
