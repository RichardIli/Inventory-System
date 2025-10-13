part of 'pull_out_office_supplies_from_db_bloc.dart';

@immutable
sealed class PullOutOfficeSuppliesFromDbState {}

final class PullOutOfficeSuppliesFromDbInitial extends PullOutOfficeSuppliesFromDbState {}

final class PullingOutOfficeSuppliesFromDb extends PullOutOfficeSuppliesFromDbState {
  final List<Map<String, dynamic>> items;

  PullingOutOfficeSuppliesFromDb({required this.items});
}

final class PulledOutOfficeSuppliesFromDb extends PullOutOfficeSuppliesFromDbState {
  final bool success;

  PulledOutOfficeSuppliesFromDb({required this.success});
}

final class PullOutOfficeSuppliesFromDbStateError extends PullOutOfficeSuppliesFromDbState {
  final String error;

  PullOutOfficeSuppliesFromDbStateError({required this.error});
}
