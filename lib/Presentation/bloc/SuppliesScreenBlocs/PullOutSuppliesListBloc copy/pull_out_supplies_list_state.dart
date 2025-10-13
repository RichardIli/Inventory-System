part of 'pull_out_supplies_list_bloc.dart';

@immutable
class PullOutSuppliesListState {}

final class PullOutSuppliesListStateInitial extends PullOutSuppliesListState {
  final List<Map<String, dynamic>> items;

  PullOutSuppliesListStateInitial({required this.items});
}

final class PullOutSuppliesListStateError extends PullOutSuppliesListState{
  final String error;
  final List<Map<String, dynamic>> items;

  PullOutSuppliesListStateError({required this.error,required this.items});
}