part of 'restock_supply_button_bloc.dart';

@immutable
sealed class RestockSupplyButtonState {}

final class RestockSupplyButtonInitial extends RestockSupplyButtonState {}

final class RestockSupplyButtonLoading extends RestockSupplyButtonState {}

final class RestockSupplyButtonLoaded extends RestockSupplyButtonState {
  final bool success;

  RestockSupplyButtonLoaded(this.success);
}

final class RestockSupplyButtonStateError extends RestockSupplyButtonState {
  final String error;

  RestockSupplyButtonStateError(this.error);
}
