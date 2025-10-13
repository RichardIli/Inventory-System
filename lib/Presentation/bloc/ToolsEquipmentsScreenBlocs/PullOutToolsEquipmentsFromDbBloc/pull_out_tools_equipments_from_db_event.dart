part of 'pull_out_tools_equipments_from_db_bloc.dart';

@immutable
sealed class PullOutToolsEquipmentsFromDbEvent {}

final class StartPullOutToolsEquipmentsFromDbEvent
    extends PullOutToolsEquipmentsFromDbEvent {
  final String outby;
  final String requestBy;
  final String receivedOnSiteBy;
  final List<Map<String, dynamic>> items;

  StartPullOutToolsEquipmentsFromDbEvent({
    required this.items,
    required this.requestBy,
    required this.receivedOnSiteBy,
    required this.outby,
  });
}

final class ResetPullOutToolsEquipmentsFromDbEvent
    extends PullOutToolsEquipmentsFromDbEvent {}
