part of 'supply_history_bloc.dart';

@immutable
sealed class SupplyHistoryState {}

final class SupplyHistoryInitial extends SupplyHistoryState {}

final class SupplyHistoryLoading extends SupplyHistoryState {}

final class SupplyHistoryLoaded extends SupplyHistoryState {
  final List<Map<String, dynamic>> data;

  SupplyHistoryLoaded(this.data);
}

final class SupplyHistoryStateError extends SupplyHistoryState{
  final String error;

  SupplyHistoryStateError(this.error);
}