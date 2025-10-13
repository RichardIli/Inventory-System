import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_system/Data/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_users_db.dart';

part 'return_tools_equipments_to_db_event.dart';
part 'return_tools_equipments_to_db_state.dart';

class ReturnToolsEquipmentsToDbBloc
    extends
        Bloc<ReturnToolsEquipmentsToDbEvent, ReturnToolsEquipmentsToDbState> {
  final FirestoreToolsEquipmentDBRepository toolsEquipmentsRepo;
  final MyFirebaseAuth auth;
  final FirestoreUsersDbRepository userDbRepo;
  final FirestoreTransmitalHistoryRepo transmitalHistoryDb;

  ReturnToolsEquipmentsToDbBloc({
    required this.toolsEquipmentsRepo,
    required this.auth,
    required this.userDbRepo,
    required this.transmitalHistoryDb,
  }) : super(ReturnToolsEquipmentsToDbInitial()) {
    on<StartReturnToolsEquipmentsToDbEvent>((event, emit) async {
      emit(ReturningToolsEquipmentsToDb());

      try {
        final currentList = event.items;
        final inBy = event.inBy;
        final email = auth.getCurrentUserEmail("user1@example.com");
        final user = userDbRepo.getUserDataBasedOnEmail(email);

        for (var item in currentList) {
          try {
            toolsEquipmentsRepo.updateItemStatus(
              id: item["id"].toString(),
              status: "STORE ROOM",
            );

            final Map<String, dynamic> transmitalsDatas = {
              'id': item["id"],
              "name": item["name"].toString(),
              "processedBy": user[0]["name"],
              "inBy": inBy,
              "inDate": DateTime.now().toUtc().toIso8601String(),
            };

            transmitalHistoryDb.recordHistory(transmitalsDatas);

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
    
    on<ResetReturnToolsEquipmentsEvent>((event, emit) {
      emit(ReturnToolsEquipmentsToDbInitial());
    });
  }
}
