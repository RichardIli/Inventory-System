part of 'selected_item_cubit.dart';

@immutable
sealed class SelectedItemState {}

final class SelectedItem extends SelectedItemState {
  final Map<String, dynamic> passedData;

  SelectedItem({required this.passedData});
}
