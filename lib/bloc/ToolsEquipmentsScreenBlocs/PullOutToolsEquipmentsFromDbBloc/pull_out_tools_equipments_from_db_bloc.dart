import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';

part 'pull_out_tools_equipments_from_db_event.dart';
part 'pull_out_tools_equipments_from_db_state.dart';

class PullOutToolsEquipmentsFromDbBloc
    extends
        Bloc<
          PullOutToolsEquipmentsFromDbEvent,
          PullOutToolsEquipmentsFromDbState
        > {
  final FirestoreToolsEquipmentDBRepository toolsEquipmentsRepo;
  final MyFirebaseAuth auth;
  final FirestoreUsersDbRepository userDbRepo;
  PullOutToolsEquipmentsFromDbBloc({
    required this.toolsEquipmentsRepo,
    required this.auth,
    required this.userDbRepo,
  }) : super(PullOutToolsEquipmentsFromDbInitial()) {
    on<StartPullOutToolsEquipmentsFromDbEvent>((event, emit) async {
      // make the showdialog not clickable when loading.
      emit(PullingOutToolsEquipmentsFromDb());

      try {
        final List<Map<String, dynamic>> currentList = event.items;
        final outBy = event.outby;
        final requestBy = event.requestBy.toUpperCase();
        final receivedOnSiteBy = event.receivedOnSiteBy.toUpperCase();
        final email = auth.getCurrentUserEmail("user1@example.com");
        final user = userDbRepo.getUserDataBasedOnEmail(email);

        for (Map<String, dynamic> item in currentList) {
          try {
            toolsEquipmentsRepo.outItem(
              item["id"],
              user[0]["name"],
              outBy,
              requestBy,
              receivedOnSiteBy,
            );
          } catch (e) {
            // ignore: avoid_print
            print("Error for item ID ${item["id"]}: $e");
          }
        }
        emit(PulledOutToolsEquipmentsFromDb(success: true));
      } catch (e) {
        emit(PullOutToolsEquipmentsFromDbStateError(error: e.toString()));
      }
    });
  }
}
