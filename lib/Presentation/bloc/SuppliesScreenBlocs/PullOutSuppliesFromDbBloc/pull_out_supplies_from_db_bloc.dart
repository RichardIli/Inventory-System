import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Data/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_supplies.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_users_db.dart';

part 'pull_out_supplies_from_db_event.dart';
part 'pull_out_supplies_from_db_state.dart';

class PullOutSuppliesFromDbBloc
    extends Bloc<PullOutSuppliesFromDbEvent, PullOutSuppliesFromDbState> {
  final FirestoreSuppliesDb suppliesDbRepo;
  final MyFirebaseAuth auth;
  final FirestoreUsersDbRepository userDbRepo;
  final FirestoreTransmitalHistoryRepo transmitalHistoryDb;
  PullOutSuppliesFromDbBloc({
    required this.suppliesDbRepo,
    required this.auth,
    required this.userDbRepo,
    required this.transmitalHistoryDb,
  }) : super(PullOutSuppliesFromDbInitial()) {
    on<StartPullOutSuppliesFromDbEvent>((event, emit) {
      try {
        final currentList = event.items;
        final requestBy = event.requestBy.toUpperCase();
        final outBy = event.outBy.toUpperCase();
        final receivedOnSiteBy = event.receivedOnSiteBy.toUpperCase();
        final email = auth.getCurrentUserEmail("user1@example.com");
        final user = userDbRepo.getUserDataBasedOnEmail(email);

        for (var item in currentList) {
          try {
            final String id = item["id"].toString();
            final double pickupAmount = item["request amount"];

            // fetch the data of the supply and get the current amount
            final Map<String, dynamic> filteredSupply = suppliesDbRepo
                .filterSupplyByExactId(id);
            final double storedAmount = filteredSupply["amount"];

            // update the list function
            suppliesDbRepo.pickupSupply(item["id"], storedAmount, pickupAmount);

            Map<String, dynamic> transmitalsDatas = {
              "id": id,
              "name": item["name"].toString(),
              "outBy": outBy,
              'processedBy': user[0]["name"],
              "receivedOnSiteBy": receivedOnSiteBy,
              "releaseDate": DateTime.now().toUtc().toIso8601String(),
              "requestBy": requestBy,
              "requestAmount": pickupAmount,
            };

            transmitalHistoryDb.recordHistory(transmitalsDatas);
          } on Exception catch (e) {
            if (kDebugMode) {
              print('Bloc Exception: $e');
            }
          }
        }

        emit(PulledOutSuppliesFromDb(success: true));
      } catch (e) {
        emit(PullOutSuppliesFromDbStateError(error: e.toString()));
      }
    });
  }
}
