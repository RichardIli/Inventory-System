import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_supplies.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
import 'package:flutter/widgets.dart';

part 'restock_supply_button_event.dart';
part 'restock_supply_button_state.dart';

class RestockSupplyButtonBloc
    extends Bloc<RestockSupplyButtonEvent, RestockSupplyButtonState> {
  final MyFirebaseAuth auth;
  final FirestoreSuppliesDb suppliesDbRepo;
  final FirestoreUsersDbRepository usersDbRepo;
  RestockSupplyButtonBloc(
      {required this.suppliesDbRepo,
      required this.usersDbRepo,
      required this.auth})
      : super(RestockSupplyButtonInitial()) {
    on<PressedRestockSupplyButtonEvent>((event, emit)  {
      emit(RestockSupplyButtonLoading());
      try {
        final String email =  auth.getCurrentUserEmail("user1@example.com");
        final List<Map<String, dynamic>> userData =
             usersDbRepo.getUserDataBasedOnEmail(email);
        final String userName = userData[0]["name"];
        final success =  suppliesDbRepo.restockSupply(
            userName, event.supplyID, event.inAmount);
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
