import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';

part 'dashboard_tools_equipments_outside_list_event.dart';
part 'dashboard_tools_equipments_outside_list_state.dart';

class DashboardToolsEquipmentsOutsideListBloc
    extends
        Bloc<
          DashboardToolsEquipmentsOutsideListEvent,
          DashboardToolsEquipmentsOutsideListState
        > {
  final FirestoreToolsEquipmentDBRepository db;
  DashboardToolsEquipmentsOutsideListBloc(this.db)
    : super(DashboardToolsEquipmentsOutsideListInitial()) {
    on<FetchDashboardToolsEquipmentsOutsideListEvent>((event, emit) async {
      emit(DashboardToolsEquipmentsOutsideListLoading());
      try {
        final List<Map<String, dynamic>> initialData = [];
        final List<Map<String, dynamic>> formatedData = [];
        final items =  db.itemsOutside();
        for (var item in items) {
          final itemToAdd = {"id": item['id'], "name": item['name']};
          initialData.add(itemToAdd);
        }
        // for (var item in initialData) {
        //   final dateOut = db.itemHistory(item['id']);
        //   final lastRecord = dateOut.last;
        //   print("hello: $lastRecord");
        //   final date = lastRecord['releaseDate'] as DateTime;
        //   final formatedDate = "${date.year}-${date.month}-${date.day}";
        //   item['date'] = formatedDate;
        //   formatedData.add(item);
        // }
        emit(DashboardToolsEquipmentsOutsideListLoaded(initialData));
      } catch (e) {
        emit(DashboardToolsEquipmentsOutsideListError(e.toString()));
      }
    });
  }
}
