part of 'selected_user_bloc.dart';

@immutable
sealed class SelectedUserEvent {}

final class SelectSelectedUserEvent extends SelectedUserEvent{
  final Map<String,dynamic> userData;

  SelectSelectedUserEvent({required this.userData});
}

final class ResetSelectedUserEvent extends SelectedUserEvent{}