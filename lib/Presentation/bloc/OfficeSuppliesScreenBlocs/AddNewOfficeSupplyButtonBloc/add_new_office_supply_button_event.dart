part of 'add_new_office_supply_button_bloc.dart';

@immutable
sealed class AddNewOfficeSupplyButtonEvent {}

final class PressedAddNewOfficeSupplyButtonEvent extends AddNewOfficeSupplyButtonEvent {
  final String supplyName;
  final double supplyAmount;
  final String unit;

  PressedAddNewOfficeSupplyButtonEvent(
      {required this.supplyName,
      required this.supplyAmount,
      required this.unit});
}

final class ResetAddNewOfficeSupplyButtonEvent
    extends AddNewOfficeSupplyButtonEvent {}