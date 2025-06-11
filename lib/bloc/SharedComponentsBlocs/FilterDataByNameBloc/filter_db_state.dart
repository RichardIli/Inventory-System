part of 'filter_db_bloc.dart';

@immutable
sealed class FilterDBState {}

final class FilterDbInitial extends FilterDBState {}

final class FilterDbLoading extends FilterDBState {}

final class FilteredDBLoaded extends FilterDBState {
  final List<Map<String, dynamic>> datas;

  FilteredDBLoaded(this.datas);
}

final class FilterDbStateError extends FilterDBState {
  final String error;

  FilterDbStateError(this.error);
}
