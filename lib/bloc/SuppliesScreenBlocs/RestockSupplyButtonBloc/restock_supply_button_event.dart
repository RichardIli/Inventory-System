part of 'restock_supply_button_bloc.dart';

@immutable
sealed class RestockSupplyButtonEvent {}

final class PressedRestockSupplyButtonEvent extends RestockSupplyButtonEvent {
  final String supplyID;
  final double inAmount;

  PressedRestockSupplyButtonEvent(
      {required this.inAmount, required this.supplyID});
}

final class ResetRestockSupplyButtonEvent extends RestockSupplyButtonEvent{
  
}