import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_bar_event.dart';
part 'search_bar_state.dart';

class SearchBarBloc extends Bloc<SearchBarEvent, SearchBarState> {
  SearchBarBloc() : super(SearchBarInitial(searchedItem: "")) {
    on<FetchSearchBarFilteredItemEvent>((event, emit) {
      final search = event.searchItem;
      emit(SearchBarInitial(searchedItem: search));
    });
  }
}
