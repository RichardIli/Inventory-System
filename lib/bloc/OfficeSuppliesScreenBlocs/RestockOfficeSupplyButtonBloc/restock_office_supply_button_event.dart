part of 'restock_office_supply_button_bloc.dart';

@immutable
sealed class RestockOfficeSupplyButtonEvent {}

final class PressedRestockOfficeSupplyButtonEvent
    extends RestockOfficeSupplyButtonEvent {
  final String supplyID;
  final double inAmount;

  PressedRestockOfficeSupplyButtonEvent(
      {required this.inAmount, required this.supplyID});
}

final class ResetRestockOfficeSupplyButtonEvent
    extends RestockOfficeSupplyButtonEvent {}
