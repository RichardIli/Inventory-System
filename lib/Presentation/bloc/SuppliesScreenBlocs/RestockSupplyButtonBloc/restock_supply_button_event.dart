part of 'restock_supply_button_bloc.dart';

@immutable
sealed class RestockSupplyButtonEvent {}

final class PressedRestockSupplyButtonEvent extends RestockSupplyButtonEvent {
  final String supplyID;
  final String supplyName;
  final double inAmount;

  PressedRestockSupplyButtonEvent({
    required this.inAmount,
    required this.supplyID,
    required this.supplyName,
  });
}

final class ResetRestockSupplyButtonEvent extends RestockSupplyButtonEvent {}
