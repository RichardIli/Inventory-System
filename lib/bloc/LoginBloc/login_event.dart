part of 'login_bloc.dart';

@immutable
sealed class LoginButtonEvent {}

final class LoginButtonPressedEvent extends LoginButtonEvent {
  final String email;
  final String password;
  final void Function() login;

  LoginButtonPressedEvent({
    required this.email,
    required this.password,
    required this.login(),
  });
}
