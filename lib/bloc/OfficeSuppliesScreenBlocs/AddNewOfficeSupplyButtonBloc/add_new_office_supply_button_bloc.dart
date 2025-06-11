import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_office_supplies.dart';
import 'package:inventory_system/Models/supply_model.dart';

part 'add_new_office_supply_button_event.dart';
part 'add_new_office_supply_button_state.dart';

class AddNewOfficeSupplyButtonBloc
    extends Bloc<AddNewOfficeSupplyButtonEvent, AddNewOfficeSupplyButtonState> {
  final FirestoreOfficeSupplies firestoreOfficeSupplies;
  AddNewOfficeSupplyButtonBloc({required this.firestoreOfficeSupplies})
      : super(AddNewOfficeSupplyInitial()) {
    on<PressedAddNewOfficeSupplyButtonEvent>((event, emit) async {
      emit(AddNewOfficeSupplyButtonLoading());
      try {
        final MyFirebaseAuth auth = MyFirebaseAuth();
        final String user =  auth.fetchAuthenticatedUserData("Sample name");
        final data = SupplyDataModel(
            amount: event.supplyAmount.round(),
            name: event.supplyName,
            unit: event.unit,
            processedBy: user);
        bool success =  firestoreOfficeSupplies.addNewOfficeSupply(data);
        emit(AddNewOfficeSupplyButtonLoaded(success));
      } catch (e) {
        emit(AddNewOfficeSupplyButtonError(e.toString()));
      }
    });

    on<ResetAddNewOfficeSupplyButtonEvent>(
        (event, emit) => emit(AddNewOfficeSupplyInitial()));
  }
}
