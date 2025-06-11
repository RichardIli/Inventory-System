part of 'pull_out_supplies_list_bloc.dart';

@immutable
sealed class PullOutSuppliesListEvent {}

final class AddItemToPullOutSuppliesListEvent extends PullOutSuppliesListEvent {
  final String idorName;
  final double amount;

  AddItemToPullOutSuppliesListEvent(
      {required this.idorName, required this.amount});
}

final class ResetPullOutSuppliesListEvent extends PullOutSuppliesListEvent {}

final class RemoveItemFormPullOutSuppliesListEvent
    extends PullOutSuppliesListEvent {
  final int index;

  RemoveItemFormPullOutSuppliesListEvent({required this.index});
}
