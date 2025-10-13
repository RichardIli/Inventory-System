import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_tools_equipment_db.dart';

part 'filter_db_event.dart';
part 'filter_db_state.dart';

class FilterDBBloc extends Bloc<FilterDBEvent, FilterDBState> {
  final FirestoreToolsEquipmentDBRepository toolsEquipmentRepo;
  FilterDBBloc(this.toolsEquipmentRepo) : super(FilterDbInitial()) {
    on<FetchFiltedDBEvent>((event, emit)  {
      emit(FilterDbLoading());
      try {
        final datas =  toolsEquipmentRepo
            .filterToolsEquipmentsByName(event.itemName);
        emit(FilteredDBLoaded(datas));
      } catch (e) {
        emit(FilterDbStateError(e.toString()));
      }
    });
  }
}
