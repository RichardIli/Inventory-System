part of 'search_bar_bloc.dart';

@immutable
sealed class SearchBarState {}

final class SearchBarInitial extends SearchBarState {
  final String searchedItem;

  SearchBarInitial({required this.searchedItem});
}

final class SearchBarStateError extends SearchBarState {
  final String error;

  SearchBarStateError({required this.error});
}
