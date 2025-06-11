import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';

part 'dashboard_users_count_event.dart';
part 'dashboard_users_count_state.dart';

class DashboardUsersCountBloc
    extends Bloc<DashboardUsersCountEvent, DashboardUsersCountState> {
  final FirestoreUsersDbRepository db;
  DashboardUsersCountBloc(this.db) : super(DashboardUsersCountInitial()) {
    on<DashboardUsersCountEvent>((event, emit)  {
      emit(DashboardUsersCountLoading());
      try {
        final data =  db.usersData();
        final count = data.length;
        emit(DashboardUsersCountLoaded(count));
      } catch (e) {
        emit(DashboardUsersCountError(e.toString()));
      }
    });
  }
}
