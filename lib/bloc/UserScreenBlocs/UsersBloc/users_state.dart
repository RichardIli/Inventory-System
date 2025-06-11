part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

class UsersStateInitial extends UsersState {}

class UsersStateLoading extends UsersState {}

class UsersStateLoaded extends UsersState {
  final List<Map<String,dynamic>> data;

  UsersStateLoaded(this.data);
}

class UsersStateError extends UsersState {
  final String error;

  UsersStateError(this.error);
}
