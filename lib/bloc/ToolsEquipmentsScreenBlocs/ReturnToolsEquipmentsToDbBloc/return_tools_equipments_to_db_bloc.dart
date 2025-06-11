import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';


part 'return_tools_equipments_to_db_event.dart';
part 'return_tools_equipments_to_db_state.dart';

class ReturnToolsEquipmentsToDbBloc extends Bloc<ReturnToolsEquipmentsToDbEvent,
    ReturnToolsEquipmentsToDbState> {
  final FirestoreToolsEquipmentDBRepository toolsEquipmentsRepo;
  final MyFirebaseAuth auth;
  final FirestoreUsersDbRepository userDbRepo;
  ReturnToolsEquipmentsToDbBloc(
      {required this.toolsEquipmentsRepo,
      required this.auth,
      required this.userDbRepo})
      : super(ReturnToolsEquipmentsToDbInitial()) {
    on<StartReturnToolsEquipmentsToDbEvent>((event, emit) async {
      emit(ReturningToolsEquipmentsToDb());

      try {
        final currentList = event.items;
        final inBy = event.inBy;
        // final email =  auth.getCurrentUserEmail();
        // final user =  userDbRepo.getUserDataBasedOnEmail(email);

        for (var item in currentList) {
          try {
            // await toolsEquipmentsRepo.returnItem(item["id"].toString(), user[0]["name"],inBy);
             toolsEquipmentsRepo.returnItem(item["id"].toString(), "Process Name Sample",inBy);
            
          } catch (e) {
            // ignore: avoid_print
            print("Error for item ID ${item["id"]}: $e");
          }
        }
        emit(ReturnedToolsEquipmentsToDb(success: true));
      } catch (e) {
        emit(ReturnToolsEquipmentsToDbStateError(error: e.toString()));
      }
    });
  }
}
