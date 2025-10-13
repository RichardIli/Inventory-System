part of 'tools_equipment_bloc.dart';

@immutable
abstract class ToolsEquipmentsState {}

class ToolsEquipmentsInitial extends ToolsEquipmentsState {}

class ToolsEquipmentsLoading extends ToolsEquipmentsState {}

class ToolsEquipmentsLoaded extends ToolsEquipmentsState {
  final List<Map<String,dynamic>> data;

  ToolsEquipmentsLoaded(this.data);
}

class ToolsEquipmentsError extends ToolsEquipmentsState {
  final String error;

  ToolsEquipmentsError(this.error);
}