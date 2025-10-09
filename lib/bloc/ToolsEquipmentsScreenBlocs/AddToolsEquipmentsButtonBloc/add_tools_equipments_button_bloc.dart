import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';

part 'add_tools_equipments_button_event.dart';
part 'add_tools_equipments_button_state.dart';

class AddToolsEquipmentsButtonBloc
    extends Bloc<AddToolsEquipmentsButtonEvent, AddToolsEquipmentsButtonState> {
  final FirestoreToolsEquipmentDBRepository db;
  final FirestoreTransmitalHistoryRepo transmitalHistoryDb;

  AddToolsEquipmentsButtonBloc(this.db, this.transmitalHistoryDb)
    : super(AddToolsEquipmentsButtonInitial()) {
    on<PressedAddToolsEquipmentsButtonEvent>((event, emit) {
      emit(AddToolsEquipmentsButtonLoading());
      try {
        // final MyFirebaseAuth auth = MyFirebaseAuth();

        // get the user by the authetication
        // final String user =  auth.fetchAuthenticatedUserData("Sample name");
        final String processedBy = "Sample name";

        bool success = db.addNewItem(
          event.itemName,
          // getting the user displayName for making an item history
          processedBy,
        );

        final List<Map<String, dynamic>> item = db.filterToolsEquipmentsByName(
          event.itemName,
        );

        final String itemId = item.first["id"].toString();

        final Map<String, dynamic> datas = {
          'id': itemId,
          "name": event.itemName,
          "processedBy": processedBy,
          "inDate": DateTime.now(),
        };

        transmitalHistoryDb.recordNewItemHistory(datas);

        emit(AddToolsEquipmentsButtonLoaded(success));
      } catch (e) {
        emit(AddToolsEquipmentsButtonError(e.toString()));
      }
    });

    on<ResetAddToolsEquipmentsButtonEvent>(
      (event, emit) => emit(AddToolsEquipmentsButtonInitial()),
    );
  }
}
