part of 'user_name_appbar_bloc.dart';

@immutable
sealed class UserNameAppbarEvent {}

final class FetchUserNameAppbarEvent extends UserNameAppbarEvent {
  final String emailAddress;
  FetchUserNameAppbarEvent({required this.emailAddress});
}
