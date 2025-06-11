part of 'tools_equipments_history_bloc.dart';

@immutable
sealed class ToolsEquipmentsHistoryState {}

class ToolsEquipmentsHistoryInitial extends ToolsEquipmentsHistoryState {}

class ToolsEquipmentsHistoryLoading extends ToolsEquipmentsHistoryState {}

class ToolsEquipmentsHistoryLoaded extends ToolsEquipmentsHistoryState {
  final List<Map<String,dynamic>> data;

  ToolsEquipmentsHistoryLoaded(this.data);
}

class ToolsEquipmentsHistoryError extends ToolsEquipmentsHistoryState {
  final String error;

  ToolsEquipmentsHistoryError(this.error);
}
