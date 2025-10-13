part of 'pull_out_supplies_from_db_bloc.dart';

@immutable
sealed class PullOutSuppliesFromDbState {}

final class PullOutSuppliesFromDbInitial extends PullOutSuppliesFromDbState {}

final class PullingOutSuppliesFromDb extends PullOutSuppliesFromDbState {
  final List<Map<String, dynamic>> items;

  PullingOutSuppliesFromDb({required this.items});
}

final class PulledOutSuppliesFromDb extends PullOutSuppliesFromDbState {
  final bool success;

  PulledOutSuppliesFromDb({required this.success});
}

final class PullOutSuppliesFromDbStateError extends PullOutSuppliesFromDbState {
  final String error;

  PullOutSuppliesFromDbStateError({required this.error});
}
