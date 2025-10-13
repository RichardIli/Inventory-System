part of 'return_tools_equipments_to_db_bloc.dart';

@immutable
sealed class ReturnToolsEquipmentsToDbState {}

final class ReturnToolsEquipmentsToDbInitial
    extends ReturnToolsEquipmentsToDbState {}

final class ReturningToolsEquipmentsToDb
    extends ReturnToolsEquipmentsToDbState {}

final class ReturnedToolsEquipmentsToDb
    extends ReturnToolsEquipmentsToDbState {
  final bool success;

  ReturnedToolsEquipmentsToDb({required this.success});
}

final class ReturnToolsEquipmentsToDbStateError
    extends ReturnToolsEquipmentsToDbState {
  final String error;

  ReturnToolsEquipmentsToDbStateError({required this.error});
}
