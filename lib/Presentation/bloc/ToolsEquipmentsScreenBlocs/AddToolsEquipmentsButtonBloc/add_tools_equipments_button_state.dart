part of 'add_tools_equipments_button_bloc.dart';

@immutable
sealed class AddToolsEquipmentsButtonState {}

final class AddToolsEquipmentsButtonInitial
    extends AddToolsEquipmentsButtonState {}

final class AddToolsEquipmentsButtonLoading
    extends AddToolsEquipmentsButtonState {}

final class AddToolsEquipmentsButtonLoaded
    extends AddToolsEquipmentsButtonState {
  final bool success;

  AddToolsEquipmentsButtonLoaded(this.success);
}

final class AddToolsEquipmentsButtonError
    extends AddToolsEquipmentsButtonState {
  final String error;
  AddToolsEquipmentsButtonError(this.error);
}
