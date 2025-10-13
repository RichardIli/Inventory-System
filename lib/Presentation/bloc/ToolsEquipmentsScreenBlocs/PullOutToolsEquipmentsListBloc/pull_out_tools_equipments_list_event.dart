part of 'pull_out_tools_equipments_list_bloc.dart';

@immutable
sealed class PullOutToolsEquipmentsListEvent {}

final class AddItemToPullOutToolsEquipmentsListEvent extends PullOutToolsEquipmentsListEvent {
  final String idorName;

  AddItemToPullOutToolsEquipmentsListEvent(
      {required this.idorName});
}

final class ResetPullOutToolsEquipmentsListEvent extends PullOutToolsEquipmentsListEvent {}

final class RemoveItemFormPullOutToolsEquipmentsListEvent
    extends PullOutToolsEquipmentsListEvent {
  final int index;

  RemoveItemFormPullOutToolsEquipmentsListEvent({required this.index});
}