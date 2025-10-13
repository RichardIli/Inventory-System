import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_transmital_history_db.dart';

part 'tools_equipments_history_event.dart';
part 'tools_equipments_history_state.dart';

class ToolsEquipmentsHistoryBloc
    extends Bloc<ToolsEquipmentsHistoryEvent, ToolsEquipmentsHistoryState> {
  // final FirestoreToolsEquipmentDBRepository db;
  final FirestoreTransmitalHistoryRepo transmitalHistoryDb;
  ToolsEquipmentsHistoryBloc({required this.transmitalHistoryDb})
    : super(ToolsEquipmentsHistoryInitial()) {
    on<FetchToolsEquipmentsHistoryEvent>((event, emit) async {
      emit(ToolsEquipmentsHistoryLoading());
      try {
        final List<Map<String, dynamic>> fetchedData = transmitalHistoryDb
            .itemHistoryComplete(itemId: event.itemId, itemName: event.itemName);

        fetchedData.sort(
          (a, b) => DateTime.parse(
            _getRecordDate(b),
          ).compareTo(DateTime.parse(_getRecordDate(a))),
        );

        // final data =  db.itemHistory(event.itemId);

        emit(ToolsEquipmentsHistoryLoaded(fetchedData));
      } catch (e) {
        emit(ToolsEquipmentsHistoryError(e.toString()));
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
