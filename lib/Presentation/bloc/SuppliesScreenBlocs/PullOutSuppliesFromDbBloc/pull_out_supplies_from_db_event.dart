part of 'pull_out_supplies_from_db_bloc.dart';

@immutable
sealed class PullOutSuppliesFromDbEvent {}

final class StartPullOutSuppliesFromDbEvent extends PullOutSuppliesFromDbEvent {
  final String requestBy, outBy, receivedOnSiteBy;
  final List<Map<String, dynamic>> items;

  StartPullOutSuppliesFromDbEvent({
    required this.items,
    required this.requestBy,
    required this.outBy,
    required this.receivedOnSiteBy,
  });
}
