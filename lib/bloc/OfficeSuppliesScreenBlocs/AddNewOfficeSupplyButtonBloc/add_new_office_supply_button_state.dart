part of 'add_new_office_supply_button_bloc.dart';

@immutable
sealed class AddNewOfficeSupplyButtonState {}

final class AddNewOfficeSupplyInitial extends AddNewOfficeSupplyButtonState {}

final class AddNewOfficeSupplyButtonLoading
    extends AddNewOfficeSupplyButtonState {}

final class AddNewOfficeSupplyButtonLoaded
    extends AddNewOfficeSupplyButtonState {
  final bool success;

  AddNewOfficeSupplyButtonLoaded(this.success);
}

final class AddNewOfficeSupplyButtonError
    extends AddNewOfficeSupplyButtonState {
  final String error;
  AddNewOfficeSupplyButtonError(this.error);
}
