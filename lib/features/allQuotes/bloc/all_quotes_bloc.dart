import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'all_quotes_event.dart';
part 'all_quotes_state.dart';

class AllQuotesBloc extends Bloc<AllQuotesEvent, AllQuotesState> {
  AllQuotesBloc() : super(AllQuotesInitial()) {}
}
