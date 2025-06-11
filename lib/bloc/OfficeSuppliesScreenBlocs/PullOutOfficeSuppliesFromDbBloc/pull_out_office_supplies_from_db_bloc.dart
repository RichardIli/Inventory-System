import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_office_supplies.dart';

part 'pull_out_office_supplies_from_db_event.dart';
part 'pull_out_office_supplies_from_db_state.dart';

class PullOutOfficeSuppliesFromDbBloc
    extends Bloc<PullOutOfficeSuppliesFromDbEvent, PullOutOfficeSuppliesFromDbState> {
  final FirestoreOfficeSupplies firestoreOfficeSupplies;
  final MyFirebaseAuth auth;
  PullOutOfficeSuppliesFromDbBloc(
      {required this.firestoreOfficeSupplies,
      required this.auth,})
      : super(PullOutOfficeSuppliesFromDbInitial()) {
    on<StartPullOutOfficeSuppliesFromDbEvent>((event, emit) async {
      try {
        final currentList = event.items;
        final requestBy = event.requestBy.toUpperCase();
        final outBy = event.outBy.toUpperCase();
        final receivedOnSiteBy = event.receivedOnSiteBy.toUpperCase();
        final String user =  auth.fetchAuthenticatedUserData("Sample name");
        for (var item in currentList) {
           firestoreOfficeSupplies.pickupSupply(item["id"], user,
              item["request amount"], requestBy, outBy, receivedOnSiteBy);
        }
      } catch (e) {
        emit(PullOutOfficeSuppliesFromDbStateError(error: e.toString()));
      }
    });
  }
}
