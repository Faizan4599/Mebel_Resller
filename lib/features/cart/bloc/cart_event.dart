part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class GetDataEvent extends CartEvent {}
