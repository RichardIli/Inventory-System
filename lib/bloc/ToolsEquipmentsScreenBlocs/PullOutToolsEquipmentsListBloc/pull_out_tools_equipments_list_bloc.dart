import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';


part 'pull_out_tools_equipments_list_event.dart';
part 'pull_out_tools_equipments_list_state.dart';

class PullOutToolsEquipmentsListBloc extends Bloc<
    PullOutToolsEquipmentsListEvent, PullOutToolsEquipmentsListState> {
  final FirestoreToolsEquipmentDBRepository toolsEquipmentsDbRepo;

  PullOutToolsEquipmentsListBloc({required this.toolsEquipmentsDbRepo})
      : super(PullOutToolsEquipmentsListStateInitial(items: [])) {
    on<AddItemToPullOutToolsEquipmentsListEvent>((event, emit)  {
      final idorName = event.idorName;

      try {
        if (state is PullOutToolsEquipmentsListStateInitial) {
          final currentSupplyList =
              (state as PullOutToolsEquipmentsListStateInitial).items;

          // Check if the item already exists in the list
          if (isAlreadyExistedInList(currentSupplyList, idorName)) {
            // Emit error state if item exists
            emit(PullOutToolsEquipmentsListStateError(
              error:
                  "Item with name or ID '$idorName' already exists in the list",
              items: currentSupplyList,
            ));
            return;
          }

          if (isID(idorName)) {
            final fetchedData =  toolsEquipmentsDbRepo
                .filterToolsEquipmentsByExactId(idorName);

             _processFetchedData(
              fetchedData,
              currentSupplyList,
              emit,
            );
          } else {
            final fetchedData =  toolsEquipmentsDbRepo
                .filterToolsEquipmentsByExactName(idorName);

             _processFetchedData(
              fetchedData,
              currentSupplyList,
              emit,
            );
          }
        }
      } catch (e) {
        emit(PullOutToolsEquipmentsListStateError(
          error: "Item doesn't Exist\n$e",
          items: (state as PullOutToolsEquipmentsListStateInitial).items,
        ));
      }
    });

    on<ResetPullOutToolsEquipmentsListEvent>((event, emit) {
      // Reset logic: Reset only the error state and maintain the list
      if (state is PullOutToolsEquipmentsListStateError) {
        // Access the current items and emit to the initial state
        final currentSupplyList =
            (state as PullOutToolsEquipmentsListStateError).items;
        emit(PullOutToolsEquipmentsListStateInitial(items: currentSupplyList));
      }
    });

    on<RemoveItemFormPullOutToolsEquipmentsListEvent>((event, emit) {
      if (state is PullOutToolsEquipmentsListStateInitial) {
        final currentSupplyList = List<Map<String, dynamic>>.from(
            (state as PullOutToolsEquipmentsListStateInitial).items);
        currentSupplyList.removeAt(event.index);

        emit(PullOutToolsEquipmentsListStateInitial(items: currentSupplyList));
      }
    });
  }

  bool isAlreadyExistedInList(
      List<Map<String, dynamic>> currentSupplyList, String idorName) {
    return currentSupplyList.any((item) =>
        item["name"] == idorName || (isID(idorName) && item["id"] == idorName));
  }

  bool isID(String idorName) {
    return double.tryParse(idorName) != null;
  }

  // Helper method to process fetched data and add to supply list
  void _processFetchedData(
    Map<String, dynamic> fetchedData,
    List<Map<String, dynamic>> currentSupplyList,
    Emitter<PullOutToolsEquipmentsListState> emit,
  )  {
    final status = fetchedData["status"];
    final record =  toolsEquipmentsDbRepo.itemHistory(fetchedData["id"]);
    final lastRecord = record.last;

    final outby = lastRecord["outBy"];
    final outdate = (lastRecord["outDate"] != null)
        ? lastRecord["outDate"]
        : null;
    final inby = lastRecord["inBy"];
    final indate = (lastRecord["inDate"] != null)
        ? lastRecord["inDate"]
        : null;
    final requestBy = lastRecord["requestBy"];
    final sitePersonel = lastRecord["site personel"];

    final formattedLastRecord =
        "In By: $inby \nIn Date: $indate \nOut By: $outby \nOut Date: $outdate \nRequest By: $requestBy \nSite Personel: $sitePersonel";

    // Checking if the item is valid for out
    if (status != "STORE ROOM") {
      emit(PullOutToolsEquipmentsListStateError(
        error:
            "The Item's Current Status is \"$status\". That means it has no record of return in the Database.\nLast Record \n$formattedLastRecord",
        items: currentSupplyList,
      ));
      return;
    }

    if (fetchedData.isEmpty) {
      emit(PullOutToolsEquipmentsListStateError(
        error: "Item does not exist",
        items: currentSupplyList,
      ));
      return;
    }

    // Add the fetchedData to the currentSupplyList
    final updatedSupplyList = List<Map<String, dynamic>>.from(currentSupplyList)
      ..add(fetchedData);

    emit(PullOutToolsEquipmentsListStateInitial(items: updatedSupplyList));
  }
}
