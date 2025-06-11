import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:flutter/widgets.dart';

part 'tools_equipments_history_event.dart';
part 'tools_equipments_history_state.dart';

class ToolsEquipmentsHistoryBloc extends Bloc<ToolsEquipmentsHistoryEvent, ToolsEquipmentsHistoryState> {
  final FirestoreToolsEquipmentDBRepository db;
  ToolsEquipmentsHistoryBloc(this.db) : super(ToolsEquipmentsHistoryInitial()) {
    on<FetchToolsEquipmentsHistoryEvent>((event, emit) async{
      emit(ToolsEquipmentsHistoryLoading());
      try {
        final data =  db.itemHistory(event.itemId);
        emit(ToolsEquipmentsHistoryLoaded(data));
      } catch (e) {
        emit(ToolsEquipmentsHistoryError(e.toString()));
      }
    });
  }
}
