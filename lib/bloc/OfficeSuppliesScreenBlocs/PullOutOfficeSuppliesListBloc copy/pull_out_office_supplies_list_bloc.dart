import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_office_supplies.dart';

part 'pull_out_office_supplies_list_event.dart';
part 'pull_out_office_supplies_list_state.dart';

class PullOutOfficeSuppliesListBloc
    extends Bloc<PullOutOfficeSuppliesListEvent, PullOutOfficeSuppliesListState> {
  final FirestoreOfficeSupplies firestoreOfficeSupplies;

  PullOutOfficeSuppliesListBloc({required this.firestoreOfficeSupplies})
      : super(PullOutOfficeSuppliesListStateInitial(items: [])) {
    on<AddItemToPullOutOfficeSuppliesListEvent>((event, emit)  {
      final requestAmount = event.amount;
      final idorName = event.idorName;

      try {
        if (state is PullOutOfficeSuppliesListStateInitial) {
          final currentSupplyList =
              (state as PullOutOfficeSuppliesListStateInitial).items;

          // Check if the item already exists in the list
          if (isAlreadyExistedInList(currentSupplyList, idorName)) {
            // Emit error state if item exists
            emit(PullOutOfficeSuppliesListStateError(
              error:
                  "Item with name or ID '$idorName' already exists in the list",
              items: currentSupplyList,
            ));
            return;
          }

          if (isID(idorName)) {
            final fetchedData =
                 firestoreOfficeSupplies.filterSupplyByExactId(idorName);

             _processFetchedData(
              requestAmount,
              fetchedData,
              currentSupplyList,
              emit,
            );
          } else {
            final fetchedData =
                 firestoreOfficeSupplies.filterSupplyByExactName(idorName);

             _processFetchedData(
              requestAmount,
              fetchedData,
              currentSupplyList,
              emit,
            );
          }
        }
      } catch (e) {
        emit(PullOutOfficeSuppliesListStateError(
          error: "Item doesn't Exist\n$e",
          items: (state as PullOutOfficeSuppliesListStateInitial).items,
        ));
      }
    });

    on<ResetPullOutOfficeSuppliesListEvent>((event, emit) {
      // Reset logic: Reset only the error state and maintain the list
      if (state is PullOutOfficeSuppliesListStateError) {
        // Access the current items and emit to the initial state
        final currentSupplyList =
            (state as PullOutOfficeSuppliesListStateError).items;
        emit(PullOutOfficeSuppliesListStateInitial(items: currentSupplyList));
      }
    });

    on<RemoveItemFormPullOutSuppliesListEvent>((event, emit) {
      if (state is PullOutOfficeSuppliesListStateInitial) {
        final currentSupplyList = List<Map<String, dynamic>>.from(
            (state as PullOutOfficeSuppliesListStateInitial).items);
        currentSupplyList.removeAt(event.index);

        emit(PullOutOfficeSuppliesListStateInitial(items: currentSupplyList));
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
  Future<void> _processFetchedData(
    double requestAmount,
    Map<String, dynamic> fetchedData,
    List<Map<String, dynamic>> currentSupplyList,
    Emitter<PullOutOfficeSuppliesListState> emit,
  ) async {
    final storedAmount = fetchedData["amount"];

    if (requestAmount > storedAmount) {
      emit(PullOutOfficeSuppliesListStateError(
        error:
            "Amount in the Database is not Enough for the Requested Amount\nRemaining Amount of ${fetchedData["name"]} stored: ${fetchedData["amount"]}",
        items: currentSupplyList,
      ));
      return;
    }

    fetchedData["request amount"] = requestAmount;

    if (fetchedData.isEmpty) {
      emit(PullOutOfficeSuppliesListStateError(
        error: "Item does not exist",
        items: currentSupplyList,
      ));
      return;
    }

    // Add the fetchedData to the currentSupplyList
    final updatedSupplyList = List<Map<String, dynamic>>.from(currentSupplyList)
      ..add(fetchedData);

    emit(PullOutOfficeSuppliesListStateInitial(items: updatedSupplyList));
  }
}
