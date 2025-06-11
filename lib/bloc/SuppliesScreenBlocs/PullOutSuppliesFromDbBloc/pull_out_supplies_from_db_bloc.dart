import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_supplies.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';

part 'pull_out_supplies_from_db_event.dart';
part 'pull_out_supplies_from_db_state.dart';

class PullOutSuppliesFromDbBloc
    extends Bloc<PullOutSuppliesFromDbEvent, PullOutSuppliesFromDbState> {
  final FirestoreSuppliesDb suppliesDbRepo;
  final MyFirebaseAuth auth;
  final FirestoreUsersDbRepository userDbRepo;
  PullOutSuppliesFromDbBloc(
      {required this.suppliesDbRepo,
      required this.auth,
      required this.userDbRepo})
      : super(PullOutSuppliesFromDbInitial()) {
    on<StartPullOutSuppliesFromDbEvent>((event, emit)  {
      try {
        final currentList = event.items;
        final requestBy = event.requestBy.toUpperCase();
        final outBy = event.outBy.toUpperCase();
        final receivedOnSiteBy = event.receivedOnSiteBy.toUpperCase();
        final email =  auth.getCurrentUserEmail("user1@example.com");
        final user =  userDbRepo.getUserDataBasedOnEmail(email);
        for (var item in currentList) {
           suppliesDbRepo.pickupSupply(item["id"], user[0]["name"],
              item["request amount"], requestBy, outBy, receivedOnSiteBy);
        }
      } catch (e) {
        emit(PullOutSuppliesFromDbStateError(error: e.toString()));
      }
    });
  }
}
