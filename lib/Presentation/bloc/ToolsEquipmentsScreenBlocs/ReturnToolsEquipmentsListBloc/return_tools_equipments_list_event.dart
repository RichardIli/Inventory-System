part of 'return_tools_equipments_list_bloc.dart';

@immutable
sealed class ReturnToolsEquipmentsListEvent {}

final class AddItemToReturnToolsEquipmentsListEvent extends ReturnToolsEquipmentsListEvent {
  final String idorName, willInBy;

  AddItemToReturnToolsEquipmentsListEvent(
      {required this.idorName,required this.willInBy});
}

final class ResetReturnToolsEquipmentsListEvent extends ReturnToolsEquipmentsListEvent {}

final class RemoveItemFormReturnToolsEquipmentsListEvent
    extends ReturnToolsEquipmentsListEvent {
  final int index;

  RemoveItemFormReturnToolsEquipmentsListEvent({required this.index});
}