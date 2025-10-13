import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_tools_equipment_db.dart';

part 'group_of_tools_equipments_count_event.dart';
part 'group_of_tools_equipments_count_state.dart';

class GroupOfToolsEquipmentsCountByNameBloc
    extends Bloc<GroupOfToolsEquipmentsCountByNameEvent, GroupOfToolsEquipmentsCountByNameState> {
  final FirestoreToolsEquipmentDBRepository toolsEquipmentsRepository;
  GroupOfToolsEquipmentsCountByNameBloc({required this.toolsEquipmentsRepository})
      : super(GroupOfToolsEquipmentsCountByNameInitial()) {
    on<FetchGroupOfToolsEquipmentsCountByNameEvent>((event, emit)  {
      emit(GroupOfToolsEquipmentsCountByNameLoading(loading()));
      try {
        final datas =  toolsEquipmentsRepository.toolsEquipmentCount();
        emit(GroupOfToolsEquipmentsCountByNameLoaded(datas));
      } catch (e) {
        emit(GroupOfToolsEquipmentsCountByNameStateError(e.toString()));
      }
    });
  }
  Widget loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
