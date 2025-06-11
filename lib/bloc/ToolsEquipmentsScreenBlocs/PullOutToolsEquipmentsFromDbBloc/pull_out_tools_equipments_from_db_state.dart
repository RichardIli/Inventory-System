part of 'pull_out_tools_equipments_from_db_bloc.dart';

@immutable
sealed class PullOutToolsEquipmentsFromDbState {}

final class PullOutToolsEquipmentsFromDbInitial
    extends PullOutToolsEquipmentsFromDbState {}

final class PullingOutToolsEquipmentsFromDb
    extends PullOutToolsEquipmentsFromDbState {}

final class PulledOutToolsEquipmentsFromDb
    extends PullOutToolsEquipmentsFromDbState {
  final bool success;

  PulledOutToolsEquipmentsFromDb({required this.success});
}

final class PullOutToolsEquipmentsFromDbStateError
    extends PullOutToolsEquipmentsFromDbState {
  final String error;

  PullOutToolsEquipmentsFromDbStateError({required this.error});
}
