import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_supplies.dart';

part 'pull_out_supplies_list_event.dart';
part 'pull_out_supplies_list_state.dart';

class PullOutSuppliesListBloc
    extends Bloc<PullOutSuppliesListEvent, PullOutSuppliesListState> {
  final FirestoreSuppliesDb suppliesDbRepository;

  PullOutSuppliesListBloc({required this.suppliesDbRepository})
      : super(PullOutSuppliesListStateInitial(items: [])) {
    on<AddItemToPullOutSuppliesListEvent>((event, emit)  {
      final requestAmount = event.amount;
      final idorName = event.idorName;

      try {
        if (state is PullOutSuppliesListStateInitial) {
          final currentSupplyList =
              (state as PullOutSuppliesListStateInitial).items;

          // Check if the item already exists in the list
          if (isAlreadyExistedInList(currentSupplyList, idorName)) {
            // Emit error state if item exists
            emit(PullOutSuppliesListStateError(
              error:
                  "Item with name or ID '$idorName' already exists in the list",
              items: currentSupplyList,
            ));
            return;
          }

          if (isID(idorName)) {
            final fetchedData =
                 suppliesDbRepository.filterSupplyByExactId(idorName);

             _processFetchedData(
              requestAmount,
              fetchedData,
              currentSupplyList,
              emit,
            );
          } else {
            final fetchedData =
                 suppliesDbRepository.filterSupplyByExactName(idorName);

             _processFetchedData(
              requestAmount,
              fetchedData,
              currentSupplyList,
              emit,
            );
          }
        }
      } catch (e) {
        emit(PullOutSuppliesListStateError(
          error: "Item doesn't Exist\n$e",
          items: (state as PullOutSuppliesListStateInitial).items,
        ));
      }
    });

    on<ResetPullOutSuppliesListEvent>((event, emit) {
      // Reset logic: Reset only the error state and maintain the list
      if (state is PullOutSuppliesListStateError) {
        // Access the current items and emit to the initial state
        final currentSupplyList =
            (state as PullOutSuppliesListStateError).items;
        emit(PullOutSuppliesListStateInitial(items: currentSupplyList));
      }
    });

    on<RemoveItemFormPullOutSuppliesListEvent>((event, emit) {
      if (state is PullOutSuppliesListStateInitial) {
        final currentSupplyList = List<Map<String, dynamic>>.from(
            (state as PullOutSuppliesListStateInitial).items);
        currentSupplyList.removeAt(event.index);

        emit(PullOutSuppliesListStateInitial(items: currentSupplyList));
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
    Emitter<PullOutSuppliesListState> emit,
  ) async {
    final storedAmount = fetchedData["amount"];

    if (requestAmount > storedAmount) {
      emit(PullOutSuppliesListStateError(
        error:
            "Amount in the Database is not Enough for the Requested Amount\nRemaining Amount of ${fetchedData["name"]} stored: ${fetchedData["amount"]}",
        items: currentSupplyList,
      ));
      return;
    }

    fetchedData["request amount"] = requestAmount;

    if (fetchedData.isEmpty) {
      emit(PullOutSuppliesListStateError(
        error: "Item does not exist",
        items: currentSupplyList,
      ));
      return;
    }

    // Add the fetchedData to the currentSupplyList
    final updatedSupplyList = List<Map<String, dynamic>>.from(currentSupplyList)
      ..add(fetchedData);

    emit(PullOutSuppliesListStateInitial(items: updatedSupplyList));
  }
}
