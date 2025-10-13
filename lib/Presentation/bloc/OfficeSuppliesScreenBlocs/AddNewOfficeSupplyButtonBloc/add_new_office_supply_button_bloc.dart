import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Data/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_office_supplies.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_users_db.dart';

part 'add_new_office_supply_button_event.dart';
part 'add_new_office_supply_button_state.dart';

class AddNewOfficeSupplyButtonBloc
    extends Bloc<AddNewOfficeSupplyButtonEvent, AddNewOfficeSupplyButtonState> {
  final FirestoreOfficeSupplies firestoreOfficeSupplies;
  final FirestoreTransmitalHistoryRepo transmitalHistoryRepo;
  AddNewOfficeSupplyButtonBloc({
    required this.firestoreOfficeSupplies,
    required this.transmitalHistoryRepo,
  }) : super(AddNewOfficeSupplyInitial()) {
    on<PressedAddNewOfficeSupplyButtonEvent>((event, emit) async {
      emit(AddNewOfficeSupplyButtonLoading());
      try {
        final FirestoreUsersDbRepository userdb = FirestoreUsersDbRepository();
        final MyFirebaseAuth auth = MyFirebaseAuth();
        final String email = auth.getCurrentUserEmail("user1@example.com");
        final List<Map<String, dynamic>> userData = userdb
            .getUserDataBasedOnEmail(email);
        final String userName = userData[0]["name"];
        final suppliesData = firestoreOfficeSupplies.officeSuppliesData();
        final String uniqueID = suppliesData.length.toString();

        Map<String, dynamic> supplyDatas = {
          "id": uniqueID,
          "name": event.supplyName,
          "amount": event.supplyAmount,
          "unit": event.unit,
        };

        bool success = firestoreOfficeSupplies.addNewOfficeSupply(supplyDatas);

        Map<String, dynamic> transmitalData = {
          "id": uniqueID,
          "name": event.supplyName,
          "processedBy": userName,
          "inDate": DateTime.now().toUtc().toIso8601String(),
          "inAmount": event.supplyAmount,
        };

        transmitalHistoryRepo.recordNewItemHistory(transmitalData);
        emit(AddNewOfficeSupplyButtonLoaded(success));
      } catch (e) {
        emit(AddNewOfficeSupplyButtonError(e.toString()));
      }
    });

    on<ResetAddNewOfficeSupplyButtonEvent>(
      (event, emit) => emit(AddNewOfficeSupplyInitial()),
    );
  }
}
