part of 'selected_item_bloc.dart';

@immutable
sealed class SelectedItemEvent {}

final class SelectSelectedItemEvent extends SelectedItemEvent {
  final Map<String, dynamic> passedData;

  SelectSelectedItemEvent({required this.passedData});
}
