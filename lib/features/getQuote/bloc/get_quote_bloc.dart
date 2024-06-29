import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_quote_event.dart';
part 'get_quote_state.dart';

class GetQuoteBloc extends Bloc<GetQuoteEvent, GetQuoteState> {
  GetQuoteBloc() : super(GetQuoteInitial()) {}
}
