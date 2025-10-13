import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_office_supplies.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_transmital_history_db.dart';

part 'office_supply_history_event.dart';
part 'office_supply_history_state.dart';

class OfficeSupplyHistoryBloc
    extends Bloc<OfficeSupplyHistoryEvent, OfficeSupplyHistoryState> {
  final FirestoreOfficeSupplies firestoreOfficeSupplies;
  final FirestoreTransmitalHistoryRepo transmitalHistoryRepo;
  OfficeSupplyHistoryBloc({
    required this.firestoreOfficeSupplies,
    required this.transmitalHistoryRepo,
  }) : super(OfficeSupplyHistoryInitial()) {
    on<FetchOfficeSupplyHistoryEvent>((event, emit) {
      emit(OfficeSupplyHistoryLoading());
      try {
        final List<Map<String, dynamic>> fetchedData = transmitalHistoryRepo
            .itemHistoryComplete(
              itemId: event.supplyID,
              itemName: event.supplyName,
            );

        fetchedData.sort(
          (a, b) => DateTime.parse(
            _getRecordDate(b),
          ).compareTo(DateTime.parse(_getRecordDate(a))),
        );

        // final data = db.supplyHistory(event.supplyID);
        emit(OfficeSupplyHistoryLoaded(fetchedData));
      } catch (e) {
        emit(OfficeSupplyHistoryStateError(e.toString()));
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
