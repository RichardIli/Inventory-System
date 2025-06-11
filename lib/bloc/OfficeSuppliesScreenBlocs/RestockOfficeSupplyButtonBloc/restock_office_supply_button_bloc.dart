import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_office_supplies.dart';

part 'restock_office_supply_button_event.dart';
part 'restock_office_supply_button_state.dart';

class RestockOfficeSupplyButtonBloc extends Bloc<RestockOfficeSupplyButtonEvent,
    RestockOfficeSupplyButtonState> {
  final MyFirebaseAuth auth;
  final FirestoreOfficeSupplies firestoreOfficeSupplies;
  RestockOfficeSupplyButtonBloc({required this.firestoreOfficeSupplies, required this.auth})
      : super(RestockOfficeSupplyButtonInitial()) {
    on<PressedRestockOfficeSupplyButtonEvent>((event, emit) async {
      emit(RestockOfficeSupplyButtonLoading());
      try {
        final String user = auth.fetchAuthenticatedUserData("Sample name");
        final success =  firestoreOfficeSupplies.restockSupply(
            user, event.supplyID, event.inAmount);
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
