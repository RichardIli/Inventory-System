import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:inventory_system/Data/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_users_db.dart';

part 'return_tools_equipments_list_event.dart';
part 'return_tools_equipments_list_state.dart';

class ReturnToolsEquipmentsListBloc
    extends
        Bloc<ReturnToolsEquipmentsListEvent, ReturnToolsEquipmentsListState> {
  final FirestoreToolsEquipmentDBRepository toolsEquipmentsDbRepo;
  final MyFirebaseAuth auth;
  final FirestoreUsersDbRepository userDbRepo;
  final FirestoreTransmitalHistoryRepo transmitalHistoryDb;

  ReturnToolsEquipmentsListBloc({
    required this.toolsEquipmentsDbRepo,
    required this.auth,
    required this.userDbRepo,
    required this.transmitalHistoryDb,
  }) : super(ReturnToolsEquipmentsListStateInitial(items: [])) {
    on<AddItemToReturnToolsEquipmentsListEvent>((event, emit) {
      final idorName = event.idorName;
      final willInBy = event.willInBy;

      // TODO: make a function or valication for duplicated item names
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
          item["name"].toString().toUpperCase() == idorName ||
          (isID(idorName) && item["id"] == idorName),
    );
  }

  bool isValidForIn(
    FirestoreToolsEquipmentDBRepository toolsEquipmentsDbRepo,
    Map<String, dynamic> fetchedData,
    List<Map<String, dynamic>> user,
    String willInBy,
  ) {
    try {
      final isValidForIn = _isValidForIn(
        fetchedData["id"],
        fetchedData["name"],
        user[0]["name"],
        willInBy.toUpperCase(),
      );
      return isValidForIn;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error checking validity for in: $e');
      }
      return false;
    }
  }

  bool _isValidForIn(
    String id,
    String itemName,
    String processedBy,
    String willInBy,
  ) {
    try {
      bool isValidForIn;
      // List<Map<String, dynamic>> history = itemHistory(id);
      List<Map<String, dynamic>> history = transmitalHistoryDb
          .itemHistoryComplete(itemId: id, itemName: itemName);

      final datas = history.last;

      if (history.length == 1) {
        isValidForIn = false;
        return isValidForIn;
      } else {
        String outBy = datas["outBy"].toString().toUpperCase();

        if (willInBy == outBy) {
          isValidForIn = true;
          return isValidForIn;
        } else {
          isValidForIn = false;
          return isValidForIn;
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error in _isValidForIn: $e');
      }
      return false;
    }
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
    final record = transmitalHistoryDb.itemHistoryComplete(
      itemId: fetchedData["id"],
      itemName: fetchedData["name"],
    );
    final lastRecord = record.last;

    final outby = lastRecord["outBy"];
    final outdate =
        (lastRecord["outDate"] != null) ? lastRecord["outDate"] : null;
    final inby = lastRecord["inBy"];
    final indate = (lastRecord["inDate"] != null) ? lastRecord["inDate"] : null;
    final requestBy = lastRecord["requestBy"];
    final receivedOnSiteBy = lastRecord["receivedOnSiteBy"];

    final formattedLastRecord =
        "In By: $inby \nIn Date: ${_formatDate(indate)} \nOut By: $outby \nOut Date: ${_formatDate(outdate)} \nRequest By: $requestBy \nSite Received On Site By: $receivedOnSiteBy";

    // Checking if the item is valid for out
    if (status != "OUTSIDE") {
      emit(
        ReturnToolsEquipmentsListStateError(
          error:
              "Item History Conflict. Item is currently in Store Room so it cant be returned.\nLast Record \n$formattedLastRecord",
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

  String _formatDate(String? isoString) {
    // check if the provided date is not null
    if (isoString == null) {
      return "";
    }

    // 1. Parse the ISO 8601 string into a DateTime object.
    // The 'Z' at the end indicates UTC time, so use parseUtc().
    final DateTime dateTime = DateTime.parse(isoString).toLocal();

    // 2. Define the desired format: dd-mm-yy (e.g., 10-03-24).
    // Use 'dd-MM-yy' where 'MM' is for the month number (padded).
    final DateFormat formatter = DateFormat('dd-MM-yy');

    // 3. Apply the format and return the string.
    return formatter.format(dateTime);
  }
}
