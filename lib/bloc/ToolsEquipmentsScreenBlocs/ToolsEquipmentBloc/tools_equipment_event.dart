part of 'tools_equipment_bloc.dart';

@immutable
sealed class ToolsEquipmentListEvent {}

class FetchToolsEquipmentsData extends ToolsEquipmentListEvent {
  final String search;

  FetchToolsEquipmentsData({required this.search});
}
