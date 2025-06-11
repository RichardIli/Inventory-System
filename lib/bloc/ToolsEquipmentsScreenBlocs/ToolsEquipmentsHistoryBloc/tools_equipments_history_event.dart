part of 'tools_equipments_history_bloc.dart';

@immutable
sealed class ToolsEquipmentsHistoryEvent {}

class FetchToolsEquipmentsHistoryEvent extends ToolsEquipmentsHistoryEvent{
  final String itemId;
  FetchToolsEquipmentsHistoryEvent({required this.itemId});
}
