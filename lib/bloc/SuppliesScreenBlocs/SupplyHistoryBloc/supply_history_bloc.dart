import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_supplies.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';

part 'supply_history_event.dart';
part 'supply_history_state.dart';

class SupplyHistoryBloc extends Bloc<SupplyHistoryEvent, SupplyHistoryState> {
  final FirestoreSuppliesDb db;
  final FirestoreTransmitalHistoryRepo transmitalHistoryRepo;
  SupplyHistoryBloc(this.db, this.transmitalHistoryRepo)
    : super(SupplyHistoryInitial()) {
    on<FetchSupplyHistoryEvent>((event, emit) async {
      emit(SupplyHistoryLoading());
      try {
        final List<Map<String, dynamic>> fetchedData = transmitalHistoryRepo
            .itemHistoryComplete(itemId: event.supplyID, itemName: event.supplyName);

        fetchedData.sort(
          (a, b) => DateTime.parse(
            _getRecordDate(b),
          ).compareTo(DateTime.parse(_getRecordDate(a))),
        );

        emit(SupplyHistoryLoaded(fetchedData));
      } catch (e) {
        emit(SupplyHistoryStateError(e.toString()));
      }
    });
  }
  String _getRecordDate(Map<String, dynamic> record) {
    // Use 'inDate' for IN transactions, or 'releaseDate' for OUT transactions.
    // We use the null-aware operator (??) to provide a fallback date.
    // We'll use a very old date as the fallback to ensure records without
    // a date (if any somehow exist) float to the beginning.
    return record['inDate'] ??
        record['releaseDate'] ??
        '1970-01-01T00:00:00.000Z';
  }
}
