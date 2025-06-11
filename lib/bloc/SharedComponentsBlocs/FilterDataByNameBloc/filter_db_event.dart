part of 'filter_db_bloc.dart';

@immutable
sealed class FilterDBEvent {}

final class FetchFiltedDBEvent extends FilterDBEvent{
  final String itemName;

  FetchFiltedDBEvent(this.itemName);
}