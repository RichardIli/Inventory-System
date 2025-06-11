import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:flutter/widgets.dart';

part 'tools_equipment_event.dart';
part 'tools_equipment_state.dart';

class ToolsEquipmentBloc
    extends Bloc<ToolsEquipmentListEvent, ToolsEquipmentsState> {
  final FirestoreToolsEquipmentDBRepository toolsEquipmentsDb;
  ToolsEquipmentBloc(this.toolsEquipmentsDb) : super(ToolsEquipmentsInitial()) {
    on<FetchToolsEquipmentsData>((event, emit)  {
      emit(ToolsEquipmentsLoading());
      try {
        if (event.search.isNotEmpty || event.search != "") {
          if (isID(event.search)) {
            final data =
                 toolsEquipmentsDb.filterToolsEquipmentsByID(event.search);
            emit(ToolsEquipmentsLoaded(data));
          } else {
            final data =  toolsEquipmentsDb
                .filterToolsEquipmentsByName(event.search);
            emit(ToolsEquipmentsLoaded(data));
          }
        } else {
          final data =  toolsEquipmentsDb.toolsEquipmentsData();
          emit(ToolsEquipmentsLoaded(data));
        }
      } catch (e) {
        emit(ToolsEquipmentsError(e.toString()));
      }
    });
  }

  bool isID(String search) {
    return double.tryParse(search) != null;
  }
}
