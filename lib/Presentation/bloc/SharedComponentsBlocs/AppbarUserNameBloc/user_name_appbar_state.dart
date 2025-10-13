part of 'user_name_appbar_bloc.dart';

@immutable
sealed class UserNameAppbarState {}

final class UserNameAppbarInitial extends UserNameAppbarState {}

final class UserNameAppbarLoading extends UserNameAppbarState {
  final Widget loadingState;

  UserNameAppbarLoading(this.loadingState);
}

final class UserNameAppbarLoaded extends UserNameAppbarState {
  final String userName;

  UserNameAppbarLoaded(this.userName);
}

final class UserNameAppbarStateError extends UserNameAppbarState {
  final Widget error;

  UserNameAppbarStateError(this.error);
}
