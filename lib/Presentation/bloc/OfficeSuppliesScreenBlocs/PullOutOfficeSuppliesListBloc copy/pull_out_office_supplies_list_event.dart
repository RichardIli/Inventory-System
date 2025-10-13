part of 'pull_out_office_supplies_list_bloc.dart';

@immutable
sealed class PullOutOfficeSuppliesListEvent {}

final class AddItemToPullOutOfficeSuppliesListEvent extends PullOutOfficeSuppliesListEvent {
  final String idorName;
  final double amount;

  AddItemToPullOutOfficeSuppliesListEvent(
      {required this.idorName, required this.amount});
}

final class ResetPullOutOfficeSuppliesListEvent extends PullOutOfficeSuppliesListEvent {}

final class RemoveItemFormPullOutSuppliesListEvent
    extends PullOutOfficeSuppliesListEvent {
  final int index;

  RemoveItemFormPullOutSuppliesListEvent({required this.index});
}
