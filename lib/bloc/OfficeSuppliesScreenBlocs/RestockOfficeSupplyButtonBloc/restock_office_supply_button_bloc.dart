import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_office_supplies.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';

part 'restock_office_supply_button_event.dart';
part 'restock_office_supply_button_state.dart';

class RestockOfficeSupplyButtonBloc
    extends
        Bloc<RestockOfficeSupplyButtonEvent, RestockOfficeSupplyButtonState> {
  final MyFirebaseAuth auth;
  final FirestoreOfficeSupplies firestoreOfficeSupplies;
  final FirestoreTransmitalHistoryRepo transmitalHistoryRepo;
  final FirestoreUsersDbRepository usersDbRepo;
  RestockOfficeSupplyButtonBloc({
    required this.firestoreOfficeSupplies,
    required this.auth,
    required this.transmitalHistoryRepo,
    required this.usersDbRepo,
  }) : super(RestockOfficeSupplyButtonInitial()) {
    on<PressedRestockOfficeSupplyButtonEvent>((event, emit) async {
      emit(RestockOfficeSupplyButtonLoading());
      try {
        final String email = auth.getCurrentUserEmail("user1@example.com");
        final List<Map<String, dynamic>> userData = usersDbRepo
            .getUserDataBasedOnEmail(email);
        final String userName = userData[0]["name"];

        final String supplyId = event.supplyID;
        final String supplyName = event.supplyName;
        final double inAmount = event.inAmount;

        // fetch the data of the supply and get the current amount
        final Map<String, dynamic> filteredSupply = firestoreOfficeSupplies
            .filterSupplyByExactId(supplyId);
        final double storedAmount = filteredSupply["amount"];

        // do the updating the value function
        final bool success = firestoreOfficeSupplies.restockSupply(
          supplyId,
          storedAmount,
          inAmount,
        );

        // create the data from that will be stored in the transmital
        Map<String, dynamic> transmitalData = {
          "id": supplyId,
          "name": supplyName,
          "processedBy": userName,
          "inDate": DateTime.now().toUtc().toIso8601String(),
          "inAmount": inAmount,
        };

        transmitalHistoryRepo.recordNewItemHistory(transmitalData);
        emit(RestockOfficeSupplyButtonLoaded(success));
      } catch (e) {
        emit(RestockOfficeSupplyButtonStateError(e.toString()));
      }
    });

    on<ResetRestockOfficeSupplyButtonEvent>(
      (event, emit) => emit(RestockOfficeSupplyButtonInitial()),
    );
  }
}
