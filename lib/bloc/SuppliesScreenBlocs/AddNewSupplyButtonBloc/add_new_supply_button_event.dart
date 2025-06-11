part of 'add_new_supply_button_bloc.dart';

@immutable
sealed class AddNewSupplyButtonEvent {}

final class PressedAddNewSupplyButtonEvent extends AddNewSupplyButtonEvent {
  final String supplyName;
  final double supplyAmount;
  final String unit;

  PressedAddNewSupplyButtonEvent(
      {required this.supplyName,
      required this.supplyAmount,
      required this.unit});
}

final class ResetAddNewSupplyButtonEvent
    extends AddNewSupplyButtonEvent {}