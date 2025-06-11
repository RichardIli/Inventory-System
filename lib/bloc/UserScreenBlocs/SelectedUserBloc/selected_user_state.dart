part of 'selected_user_bloc.dart';

@immutable
sealed class SelectedUserState {}

final class SelectedUserInitial extends SelectedUserState {}

final class SelectedUserLoading extends SelectedUserState {}

final class SelectedUserLoaded extends SelectedUserState {
  final Map<String, dynamic> userData;

  SelectedUserLoaded({required this.userData});
}

final class SelectedUserError extends SelectedUserState {
  final String error;

  SelectedUserError({required this.error});
}
