part of 'tools_equipments_history_bloc.dart';

@immutable
sealed class ToolsEquipmentsHistoryEvent {}

class FetchToolsEquipmentsHistoryEvent extends ToolsEquipmentsHistoryEvent{
  final String itemId;
  final String itemName;
  FetchToolsEquipmentsHistoryEvent({required this.itemId,required this.itemName});
}
