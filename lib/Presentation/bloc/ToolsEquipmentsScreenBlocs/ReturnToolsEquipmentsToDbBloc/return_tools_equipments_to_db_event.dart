part of 'return_tools_equipments_to_db_bloc.dart';

@immutable
sealed class ReturnToolsEquipmentsToDbEvent {}

final class StartReturnToolsEquipmentsToDbEvent
    extends ReturnToolsEquipmentsToDbEvent {
  final List<Map<String, dynamic>> items;
  final String inBy;

  StartReturnToolsEquipmentsToDbEvent({
    required this.items,
    required this.inBy,
  });
}

final class ResetReturnToolsEquipmentsEvent
    extends ReturnToolsEquipmentsToDbEvent {}
