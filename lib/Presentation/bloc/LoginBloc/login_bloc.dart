import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Data/FirebaseConnection/firebaseauth_connection.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginButtonBloc extends Bloc<LoginButtonEvent, LoginButtonState> {
  final MyFirebaseAuth auth;
  LoginButtonBloc(this.auth) : super(LoginInitial()) {
    on<LoginButtonPressedEvent>((event, emit) async {
      try {
        bool loginData = auth.login(
            emailAddress: event.email,
            password: event.password);

        if (loginData) {
          event.login();
        }
      } catch (e) {
        // ignore: avoid_print
        print("ERROR: $e");
      }
    });
  }
}
