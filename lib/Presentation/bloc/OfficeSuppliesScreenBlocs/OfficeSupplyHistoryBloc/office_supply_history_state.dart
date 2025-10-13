part of 'office_supply_history_bloc.dart';

@immutable
sealed class OfficeSupplyHistoryState {}

final class OfficeSupplyHistoryInitial extends OfficeSupplyHistoryState {}

final class OfficeSupplyHistoryLoading extends OfficeSupplyHistoryState {}

final class OfficeSupplyHistoryLoaded extends OfficeSupplyHistoryState {
  final List<Map<String, dynamic>> data;

  OfficeSupplyHistoryLoaded(this.data);
}

final class OfficeSupplyHistoryStateError extends OfficeSupplyHistoryState{
  final String error;

  OfficeSupplyHistoryStateError(this.error);
}