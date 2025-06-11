part of 'restock_office_supply_button_bloc.dart';

@immutable
sealed class RestockOfficeSupplyButtonState {}

final class RestockOfficeSupplyButtonInitial extends RestockOfficeSupplyButtonState {}

final class RestockOfficeSupplyButtonLoading extends RestockOfficeSupplyButtonState {}

final class RestockOfficeSupplyButtonLoaded extends RestockOfficeSupplyButtonState {
  final bool success;

  RestockOfficeSupplyButtonLoaded(this.success);
}

final class RestockOfficeSupplyButtonStateError extends RestockOfficeSupplyButtonState {
  final String error;

  RestockOfficeSupplyButtonStateError(this.error);
}
