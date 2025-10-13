part of 'pull_out_office_supplies_from_db_bloc.dart';

@immutable
sealed class PullOutOfficeSuppliesFromDbEvent {}

final class StartPullOutOfficeSuppliesFromDbEvent extends PullOutOfficeSuppliesFromDbEvent {
  final String requestBy, outBy, receivedOnSiteBy;
  final List<Map<String, dynamic>> items;

  StartPullOutOfficeSuppliesFromDbEvent({
    required this.items,
    required this.requestBy,
    required this.outBy,
    required this.receivedOnSiteBy,
  });
}
