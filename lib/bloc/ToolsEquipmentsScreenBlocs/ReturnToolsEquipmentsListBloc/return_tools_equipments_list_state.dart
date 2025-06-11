part of 'return_tools_equipments_list_bloc.dart';

@immutable
class ReturnToolsEquipmentsListState {}

final class ReturnToolsEquipmentsListStateInitial extends ReturnToolsEquipmentsListState {
  final List<Map<String, dynamic>> items;

  ReturnToolsEquipmentsListStateInitial({required this.items});
}

final class ReturnToolsEquipmentsListStateError extends ReturnToolsEquipmentsListState{
  final String error;
  final List<Map<String, dynamic>> items;

  ReturnToolsEquipmentsListStateError({required this.error,required this.items});
}