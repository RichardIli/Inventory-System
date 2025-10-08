part of 'add_user_cubit.dart';

@immutable
sealed class AddUserState {}

final class AddUserInitial extends AddUserState {}

final class AddUserLoading extends AddUserState {}

final class AddUserSuccess extends AddUserState {}

final class AddUserFailure extends AddUserState {
  final String error;
  AddUserFailure(this.error);
}
