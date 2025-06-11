import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_supplies.dart';
import 'package:flutter/widgets.dart';

part 'supplies_event.dart';
part 'supplies_state.dart';

class SuppliesBloc extends Bloc<SuppliesEvent, SuppliesState> {
  final FirestoreSuppliesDb db;
  SuppliesBloc(this.db) : super(SuppliesInitial()) {
    on<FetchSuppliesEvent>((event, emit)  {
      emit(SuppliesLoading());
      try {
        if (event.search.isNotEmpty || event.search != "") {
          if (isID(event.search)) {
            final data =  db.filterSuppliesById(event.search);
            emit(SuppliesLoaded(data));
          } else {
            final data =  db.filterSuppliesByName(event.search);
            emit(SuppliesLoaded(data));
          }
        } else {
          final data =  db.suppliesData();
          emit(SuppliesLoaded(data));
        }
      } catch (e) {
        emit(SuppliesStateError(e.toString()));
      }
    });
  }
  bool isID(String search) {
    return double.tryParse(search) != null;
  }
}

// if (event.search.isNotEmpty || event.search != "") {
//           if (isID(event.search)) {
//             final data =
//                 await toolsEquipmentsDb.filterToolsEquipmentsByID(event.search);
//             emit(ToolsEquipmentsLoaded(data));
//           } else {
//             final data = await toolsEquipmentsDb
//                 .filterToolsEquipmentsByName(event.search);
//             emit(ToolsEquipmentsLoaded(data));
//           }
//         } else {
//           final data = await toolsEquipmentsDb.toolsEquipmentsData();
//           emit(ToolsEquipmentsLoaded(data));
//         }
//       } catch (e) {
//         emit(ToolsEquipmentsError(e.toString()));
//       }
