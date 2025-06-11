import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';

part 'filter_data_by_status_event.dart';
part 'filter_data_by_status_state.dart';

class FilterDataByStatusBloc
    extends Bloc<FilterDataByStatusEvent, FilterDataByStatusState> {
  final FirestoreToolsEquipmentDBRepository toolsEquipmentsRepo;
  FilterDataByStatusBloc(this.toolsEquipmentsRepo)
    : super(FilterDataByStatusInitial()) {
    on<FetchFilteredDataByStatusEvent>((event, emit) {
      emit(FilterDataByStatusLoading());
      try {
        List<Map<String, dynamic>> storedToolsData = toolsEquipmentsRepo
            .filterToolsEquipmentsByStatus("STORE ROOM", event.nameToFilter);
        List<Map<String, dynamic>> outSideToolsData = toolsEquipmentsRepo
            .filterToolsEquipmentsByStatus("OUTSIDE", event.nameToFilter);
        emit(
          FilterDataByStatusLoaded(
            storedToolsData: storedToolsData,
            outSideToolsData: outSideToolsData,
          ),
        );
      } catch (e) {
        emit(FilterDataByStatusStateError(error: e.toString()));
      }
    });
  }
}
