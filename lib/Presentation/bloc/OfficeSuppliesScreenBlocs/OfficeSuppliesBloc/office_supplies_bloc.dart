import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_office_supplies.dart';

part 'office_supplies_event.dart';
part 'office_supplies_state.dart';

class OfficeSuppliesBloc
    extends Bloc<OfficeSuppliesEvent, OfficeSuppliesState> {
  final FirestoreOfficeSupplies firestoreOfficeSupplies;
  OfficeSuppliesBloc({required this.firestoreOfficeSupplies})
      : super(OfficeSuppliesInitial()) {
    on<FetchOfficeSuppliesEvent>((event, emit) async {
      emit(OfficeSuppliesLoading());
      try {
        if (event.search.isNotEmpty || event.search != "") {
          if (isID(event.search)) {
            final data =
                 firestoreOfficeSupplies.filterSuppliesById(event.search);
            emit(OfficeSuppliesLoaded(data));
          } else {
            final data =  firestoreOfficeSupplies
                .filterSuppliesByName(event.search);
            emit(OfficeSuppliesLoaded(data));
          }
        } else {
          final rawData =  firestoreOfficeSupplies.fetchItems();
          final List<Map<String, dynamic>> data =
              List.generate(rawData.length, (index) {
            return {
              "amount": rawData[index].amount,
              "id": rawData[index].id,
              "name": rawData[index].name,
              "unit": rawData[index].unit,
            };
          });
          emit(OfficeSuppliesLoaded(data));
        }
      } catch (e) {
        emit(OfficeSuppliesStateError(e.toString()));
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
