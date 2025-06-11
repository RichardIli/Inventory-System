part of 'selected_item_bloc.dart';

@immutable
sealed class SelectedItemState {}

final class SelectedItemInitial extends SelectedItemState {}

final class SelectedItemLoading extends SelectedItemState {}

final class SelectedItemLoaded extends SelectedItemState {
  final Map<String, dynamic> passedData;

  SelectedItemLoaded({required this.passedData});
}

final class SelectedItemError extends SelectedItemState {
  final String error;

  SelectedItemError({required this.error});
}
