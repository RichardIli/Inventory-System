part of 'pull_out_office_supplies_list_bloc.dart';

@immutable
class PullOutOfficeSuppliesListState {}

final class PullOutOfficeSuppliesListStateInitial extends PullOutOfficeSuppliesListState {
  final List<Map<String, dynamic>> items;

  PullOutOfficeSuppliesListStateInitial({required this.items});
}

final class PullOutOfficeSuppliesListStateError extends PullOutOfficeSuppliesListState{
  final String error;
  final List<Map<String, dynamic>> items;

  PullOutOfficeSuppliesListStateError({required this.error,required this.items});
}