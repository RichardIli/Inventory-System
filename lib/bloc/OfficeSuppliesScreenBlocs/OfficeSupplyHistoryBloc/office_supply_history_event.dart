part of 'office_supply_history_bloc.dart';

@immutable
sealed class OfficeSupplyHistoryEvent {}

final class FetchOfficeSupplyHistoryEvent extends OfficeSupplyHistoryEvent{
  final String supplyID;

  FetchOfficeSupplyHistoryEvent({required this.supplyID});
}