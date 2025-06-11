import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_supplies.dart';
import 'package:flutter/widgets.dart';

part 'supply_history_event.dart';
part 'supply_history_state.dart';

class SupplyHistoryBloc extends Bloc<SupplyHistoryEvent, SupplyHistoryState> {
  final FirestoreSuppliesDb db;
  SupplyHistoryBloc(this.db) : super(SupplyHistoryInitial()) {
    on<FetchSupplyHistoryEvent>((event, emit) async {
      emit(SupplyHistoryLoading());
      try {
        final data =  db.supplyHistory(event.supplyID);
        emit(SupplyHistoryLoaded(data));
      } catch (e) {
        emit(SupplyHistoryStateError(e.toString()));
      }
    });
  }
}
