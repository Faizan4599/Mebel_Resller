part of 'quote_bloc.dart';

@immutable
abstract class QuoteEvent {}

class QuoteSlideImageEvent extends QuoteEvent {
  final int currentPage;
  QuoteSlideImageEvent({required this.currentPage});
}

class QuoteGotoAddToCartEvent extends QuoteEvent {}
