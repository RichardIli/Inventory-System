import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
import 'package:flutter/widgets.dart';

part 'return_tools_equipments_list_event.dart';
part 'return_tools_equipments_list_state.dart';

class ReturnToolsEquipmentsListBloc
    extends
        Bloc<ReturnToolsEquipmentsListEvent, ReturnToolsEquipmentsListState> {
  final FirestoreToolsEquipmentDBRepository toolsEquipmentsDbRepo;
  final MyFirebaseAuth auth;
  final FirestoreUsersDbRepository userDbRepo;

  ReturnToolsEquipmentsListBloc({
    required this.toolsEquipmentsDbRepo,
    required this.auth,
    required this.userDbRepo,
  }) : super(ReturnToolsEquipmentsListStateInitial(items: [])) {
    on<AddItemToReturnToolsEquipmentsListEvent>((event, emit) {
      final idorName = event.idorName;
      final willInBy = event.willInBy;

      try {
        if (state is ReturnToolsEquipmentsListStateInitial) {
          final currentSupplyList =
              (state as ReturnToolsEquipmentsListStateInitial).items;

          // Check if the item already exists in the list
          if (isAlreadyExistedInList(currentSupplyList, idorName)) {
            // Emit error state if item exists
            emit(
              ReturnToolsEquipmentsListStateError(
                error:
                    "Item with name or ID '$idorName' already exists in the list",
                items: currentSupplyList,
              ),
            );
            return;
          }

          if (isID(idorName)) {
            final fetchedData = toolsEquipmentsDbRepo
                .filterToolsEquipmentsByExactId(idorName);

            _processFetchedData(fetchedData, currentSupplyList, emit, willInBy);
          } else {
            final fetchedData = toolsEquipmentsDbRepo
                .filterToolsEquipmentsByExactName(idorName);

            _processFetchedData(fetchedData, currentSupplyList, emit, willInBy);
          }
        }
      } catch (e) {
        emit(
          ReturnToolsEquipmentsListStateError(
            error: "Item doesn't Exist\n$e",
            items: (state as ReturnToolsEquipmentsListStateInitial).items,
          ),
        );
      }
    });

    on<ResetReturnToolsEquipmentsListEvent>((event, emit) {
      // Reset logic: Reset only the error state and maintain the list
      if (state is ReturnToolsEquipmentsListStateError) {
        // Access the current items and emit to the initial state
        final currentSupplyList =
            (state as ReturnToolsEquipmentsListStateError).items;
        emit(ReturnToolsEquipmentsListStateInitial(items: currentSupplyList));
      }
    });

    on<RemoveItemFormReturnToolsEquipmentsListEvent>((event, emit) {
      if (state is ReturnToolsEquipmentsListStateInitial) {
        final currentSupplyList = List<Map<String, dynamic>>.from(
          (state as ReturnToolsEquipmentsListStateInitial).items,
        );
        currentSupplyList.removeAt(event.index);

        emit(ReturnToolsEquipmentsListStateInitial(items: currentSupplyList));
      }
    });
  }

  bool isAlreadyExistedInList(
    List<Map<String, dynamic>> currentSupplyList,
    String idorName,
  ) {
    return currentSupplyList.any(
      (item) =>
          item["name"] == idorName ||
          (isID(idorName) && item["id"] == idorName),
    );
  }

  bool isValidForIn(
    FirestoreToolsEquipmentDBRepository toolsEquipmentsDbRepo,
    Map<String, dynamic> fetchedData,
    List<Map<String, dynamic>> user,
    String willInBy,
  ) {
    // TODO: I think the problem here is the id because im not sure if that exist in the list
    final isValidForIn = toolsEquipmentsDbRepo.isValidForIn(
      fetchedData["id"],
      user[0]["name"],
      willInBy.toUpperCase(),
    );
    return isValidForIn;
  }

  bool isID(String idorName) {
    return double.tryParse(idorName) != null;
  }

  // Helper method to process fetched data and add to supply list
  void _processFetchedData(
    Map<String, dynamic> fetchedData,
    List<Map<String, dynamic>> currentSupplyList,
    Emitter<ReturnToolsEquipmentsListState> emit,
    String willInBy,
  ) {
    final status = fetchedData["status"];
    final record = toolsEquipmentsDbRepo.itemHistory(fetchedData["id"]);
    final lastRecord = record.last;

    final outby = lastRecord["outBy"];
    final outdate =
        (lastRecord["outDate"] != null) ? lastRecord["outDate"] : null;
    final inby = lastRecord["inBy"];
    final indate = (lastRecord["inDate"] != null) ? lastRecord["inDate"] : null;
    final requestBy = lastRecord["requestBy"];
    final receivedOnSiteBy = lastRecord["receivedOnSiteBy"];

    final formattedLastRecord =
        "In By: $inby \nIn Date: $indate \nOut By: $outby \nOut Date: $outdate \nRequest By: $requestBy \nSite Received On Site By: $receivedOnSiteBy";

    // Checking if the item is valid for out
    if (status != "OUTSIDE") {
      emit(
        ReturnToolsEquipmentsListStateError(
          error: "Item History Conflict.\nLast Record \n$formattedLastRecord",
          items: currentSupplyList,
        ),
      );
      return;
    }

    final email = auth.getCurrentUserEmail("user1@example.com");
    final user = userDbRepo.getUserDataBasedOnEmail(email);
    final isvalidForIn = isValidForIn(
      toolsEquipmentsDbRepo,
      fetchedData,
      user,
      willInBy,
    );

    if (!isvalidForIn) {
      emit(
        ReturnToolsEquipmentsListStateError(
          error: "Item History Conflict.\nLast Record \n$formattedLastRecord",
          items: currentSupplyList,
        ),
      );
      return;
    }

    if (fetchedData.isEmpty) {
      emit(
        ReturnToolsEquipmentsListStateError(
          error: "Item does not exist",
          items: currentSupplyList,
        ),
      );
      return;
    }

    // Add the fetchedData to the currentSupplyList
    final updatedSupplyList = List<Map<String, dynamic>>.from(currentSupplyList)
      ..add(fetchedData);

    emit(ReturnToolsEquipmentsListStateInitial(items: updatedSupplyList));
  }
}
