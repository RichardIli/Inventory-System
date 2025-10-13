import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Data/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_users_db.dart';

part 'add_tools_equipments_button_event.dart';
part 'add_tools_equipments_button_state.dart';

class AddToolsEquipmentsButtonBloc
    extends Bloc<AddToolsEquipmentsButtonEvent, AddToolsEquipmentsButtonState> {
  final MyFirebaseAuth auth;
  final FirestoreUsersDbRepository userDbRepo;
  final FirestoreToolsEquipmentDBRepository db;
  final FirestoreTransmitalHistoryRepo transmitalHistoryDb;

  AddToolsEquipmentsButtonBloc(
    this.db,
    this.transmitalHistoryDb,
    this.auth,
    this.userDbRepo,
  ) : super(AddToolsEquipmentsButtonInitial()) {
    on<PressedAddToolsEquipmentsButtonEvent>((event, emit) {
      emit(AddToolsEquipmentsButtonLoading());
      try {

        final email = auth.getCurrentUserEmail("user1@example.com");
        final user = userDbRepo.getUserDataBasedOnEmail(email);
        final String processedBy = user[0]["name"].toString();

        final Map<String, dynamic> itemData = {
          "name": event.itemName,
          "processedBy": processedBy,
          "inDate": DateTime.now().toUtc().toIso8601String(),
          "isArchive": false,
          "status": "STORE ROOM",
        };

        List success = db.addNewItem(itemData);

        // fetch the updated data after adding the unique ID
        transmitalHistoryDb.recordNewItemHistory(success[1]);

        emit(AddToolsEquipmentsButtonLoaded(success[0]));
      } catch (e) {
        emit(AddToolsEquipmentsButtonError(e.toString()));
      }
    });

    on<ResetAddToolsEquipmentsButtonEvent>(
      (event, emit) => emit(AddToolsEquipmentsButtonInitial()),
    );
  }
}
