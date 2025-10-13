part of 'add_tools_equipments_button_bloc.dart';

@immutable
sealed class AddToolsEquipmentsButtonEvent {}

final class PressedAddToolsEquipmentsButtonEvent
    extends AddToolsEquipmentsButtonEvent {
  final String itemName;

  PressedAddToolsEquipmentsButtonEvent({required this.itemName});
}

final class ResetAddToolsEquipmentsButtonEvent
    extends AddToolsEquipmentsButtonEvent {}
