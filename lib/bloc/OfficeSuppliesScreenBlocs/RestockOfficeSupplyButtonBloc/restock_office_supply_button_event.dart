part of 'restock_office_supply_button_bloc.dart';

@immutable
sealed class RestockOfficeSupplyButtonEvent {}

final class PressedRestockOfficeSupplyButtonEvent
    extends RestockOfficeSupplyButtonEvent {
  final String supplyID;
  final String supplyName;
  final double inAmount;

  PressedRestockOfficeSupplyButtonEvent(
      {required this.inAmount, required this.supplyID,required this.supplyName});
}

final class ResetRestockOfficeSupplyButtonEvent
    extends RestockOfficeSupplyButtonEvent {}
