part of 'supply_history_bloc.dart';

@immutable
sealed class SupplyHistoryEvent {}

final class FetchSupplyHistoryEvent extends SupplyHistoryEvent{
  final String supplyID;
  final String supplyName;

  FetchSupplyHistoryEvent({required this.supplyID,required this.supplyName});
}