import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_supplies.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';

part 'add_new_supply_button_event.dart';
part 'add_new_supply_button_state.dart';

class AddNewSupplyButtonBloc
    extends Bloc<AddNewSupplyButtonEvent, AddNewSupplyButtonState> {
  final FirestoreSuppliesDb db;
  final FirestoreTransmitalHistoryRepo transmitalHistoryRepo;
  AddNewSupplyButtonBloc(this.db, this.transmitalHistoryRepo)
    : super(AddNewSupplyInitial()) {
    on<PressedAddNewSupplyButtonEvent>((event, emit) {
      emit(AddNewSupplyButtonLoading());
      try {
        final FirestoreUsersDbRepository userdb = FirestoreUsersDbRepository();
        final MyFirebaseAuth auth = MyFirebaseAuth();
        final String email = auth.getCurrentUserEmail("user1@example.com");
        final List<Map<String, dynamic>> userData = userdb
            .getUserDataBasedOnEmail(email);
        final String userName = userData[0]["name"];
        final suppliesData = db.suppliesData();
        final String uniqueID = suppliesData.length.toString();

        Map<String, dynamic> supplyDatas = {
          "id": uniqueID,
          "name": event.supplyName,
          "amount": event.supplyAmount,
          "unit": event.unit,
        };

        bool success = db.addNewSupply(supplyDatas);

        Map<String, dynamic> transmitalData = {
          "id": uniqueID,
          "name": event.supplyName,
          "processedBy": userName,
          "inDate": DateTime.now().toUtc().toIso8601String(),
          "inAmount": event.supplyAmount,
        };

        transmitalHistoryRepo.recordNewItemHistory(transmitalData);

        emit(AddNewSupplyButtonLoaded(success));
      } catch (e) {
        emit(AddNewSupplyButtonError(e.toString()));
      }
    });

    on<ResetAddNewSupplyButtonEvent>(
      (event, emit) => emit(AddNewSupplyInitial()),
    );
  }
}
