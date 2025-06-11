part of 'add_new_supply_button_bloc.dart';

@immutable
sealed class AddNewSupplyButtonState {}

final class AddNewSupplyInitial extends AddNewSupplyButtonState {}

final class AddNewSupplyButtonLoading
    extends AddNewSupplyButtonState {}

final class AddNewSupplyButtonLoaded
    extends AddNewSupplyButtonState {
  final bool success;

  AddNewSupplyButtonLoaded(this.success);
}

final class AddNewSupplyButtonError
    extends AddNewSupplyButtonState {
  final String error;
  AddNewSupplyButtonError(this.error);
}
