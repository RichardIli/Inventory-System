import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final FirestoreUsersDbRepository db;
  UsersBloc(this.db) : super(UsersStateInitial()) {
    on<FetchUsersEvent>((event, emit) async{
      emit(UsersStateLoading());
      try {
         final data =  db.usersData();
        emit(UsersStateLoaded(data));
      } catch (e) {
        emit(UsersStateError(e.toString()));
      }
    });
  }
}
