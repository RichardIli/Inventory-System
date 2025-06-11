part of 'search_bar_bloc.dart';

@immutable
sealed class SearchBarEvent {}

final class FetchSearchBarFilteredItemEvent extends SearchBarEvent {
  final String searchItem;

  FetchSearchBarFilteredItemEvent({required this.searchItem});
}