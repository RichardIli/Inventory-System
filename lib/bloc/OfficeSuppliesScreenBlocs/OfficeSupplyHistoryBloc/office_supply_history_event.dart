part of 'office_supply_history_bloc.dart';

@immutable
sealed class OfficeSupplyHistoryEvent {}

final class FetchOfficeSupplyHistoryEvent extends OfficeSupplyHistoryEvent{
  final String supplyID;
  final String supplyName;

  FetchOfficeSupplyHistoryEvent({required this.supplyID,required this.supplyName});
}