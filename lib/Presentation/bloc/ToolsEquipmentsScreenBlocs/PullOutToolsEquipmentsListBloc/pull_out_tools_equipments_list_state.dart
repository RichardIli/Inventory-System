part of 'pull_out_tools_equipments_list_bloc.dart';

@immutable
class PullOutToolsEquipmentsListState {}

final class PullOutToolsEquipmentsListStateInitial extends PullOutToolsEquipmentsListState {
  final List<Map<String, dynamic>> items;

  PullOutToolsEquipmentsListStateInitial({required this.items});
}

final class PullOutToolsEquipmentsListStateError extends PullOutToolsEquipmentsListState{
  final String error;
  final List<Map<String, dynamic>> items;

  PullOutToolsEquipmentsListStateError({required this.error,required this.items});
}