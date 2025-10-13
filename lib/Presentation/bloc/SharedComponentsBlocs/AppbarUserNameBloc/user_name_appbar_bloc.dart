import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Data/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_users_db.dart';

part 'user_name_appbar_event.dart';
part 'user_name_appbar_state.dart';

class UserNameAppbarBloc
    extends Bloc<UserNameAppbarEvent, UserNameAppbarState> {
  final MyFirebaseAuth auth;
  final FirestoreUsersDbRepository userRepository;
  UserNameAppbarBloc({required this.auth, required this.userRepository})
      : super(UserNameAppbarInitial()) {
    on<FetchUserNameAppbarEvent>((event, emit) {
      emit(UserNameAppbarLoading(loadingState()));
      try {
        final String email =   auth.getCurrentUserEmail(event.emailAddress);
        final userData =  userRepository.getUserDataBasedOnEmail(email);
        final String userName = userData.first["name"];
        emit(UserNameAppbarLoaded(userName));
      } catch (e) {
        emit(UserNameAppbarStateError(errorState(e.toString())));
      }
    });
  }

  Widget loadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget errorState(String error){
    return Center(child: Text(error),);
  }
}
