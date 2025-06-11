import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_office_supplies.dart';

part 'office_supply_history_event.dart';
part 'office_supply_history_state.dart';

class OfficeSupplyHistoryBloc
    extends Bloc<OfficeSupplyHistoryEvent, OfficeSupplyHistoryState> {
  final FirestoreOfficeSupplies firestoreOfficeSupplies;
  OfficeSupplyHistoryBloc({required this.firestoreOfficeSupplies}) : super(OfficeSupplyHistoryInitial()) {
    on<FetchOfficeSupplyHistoryEvent>((event, emit)  {
      emit(OfficeSupplyHistoryLoading());
      try {
        final data =  firestoreOfficeSupplies.supplyHistory(event.supplyID);
        emit(OfficeSupplyHistoryLoaded(data));
      } catch (e) {
        emit(OfficeSupplyHistoryStateError(e.toString()));
      }
    });
  }
}
