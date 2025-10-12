import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_supplies.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
import 'package:flutter/widgets.dart';

part 'restock_supply_button_event.dart';
part 'restock_supply_button_state.dart';

class RestockSupplyButtonBloc
    extends Bloc<RestockSupplyButtonEvent, RestockSupplyButtonState> {
  final MyFirebaseAuth auth;
  final FirestoreSuppliesDb suppliesDbRepo;
  final FirestoreUsersDbRepository usersDbRepo;
  final FirestoreTransmitalHistoryRepo transmitalHistoryRepo;
  RestockSupplyButtonBloc({
    required this.suppliesDbRepo,
    required this.usersDbRepo,
    required this.auth,
    required this.transmitalHistoryRepo,
  }) : super(RestockSupplyButtonInitial()) {
    on<PressedRestockSupplyButtonEvent>((event, emit) {
      emit(RestockSupplyButtonLoading());
      try {
        final String email = auth.getCurrentUserEmail("user1@example.com");
        final List<Map<String, dynamic>> userData = usersDbRepo
            .getUserDataBasedOnEmail(email);
        final String userName = userData[0]["name"];

        final String supplyId = event.supplyID;
        final String supplyName = event.supplyName;
        final double inAmount = event.inAmount;

        // fetch the data of the supply and get the current amount
        final Map<String, dynamic> filteredSupply = suppliesDbRepo
            .filterSupplyByExactId(supplyId);
        final double storedAmount = filteredSupply["amount"];

        // do the updating the value function
        final bool success = suppliesDbRepo.restockSupply(
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

        emit(RestockSupplyButtonLoaded(success));
      } catch (e) {
        emit(RestockSupplyButtonStateError(e.toString()));
      }
    });

    on<ResetRestockSupplyButtonEvent>(
      (event, emit) => emit(RestockSupplyButtonInitial()),
    );
  }
}
