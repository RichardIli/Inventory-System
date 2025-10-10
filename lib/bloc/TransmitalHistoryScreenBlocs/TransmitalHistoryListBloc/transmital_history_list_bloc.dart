import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:flutter/widgets.dart';

part 'transmital_history_list_event.dart';
part 'transmital_history_list_state.dart';

class TransmitalHistoryListBloc
    extends Bloc<TransmitalHistoryListEvent, TransmitalHistoryListState> {
  final FirestoreTransmitalHistoryRepo transmitalHistoryRepo;
  TransmitalHistoryListBloc({required this.transmitalHistoryRepo})
    : super(TransmitalHistoryListInitial()) {
    on<FetchTransmitalHistoryListEvent>((event, emit) {
      emit(TransmitalHistoryListLoading());
      try {
        // TODO: FIND THE REASON WHY EVERYTIME I ADD A NEW ITEM THE ASCENDING ORDER WONT WORK
        final transmitals = transmitalHistoryRepo.fetchTransmitalHistory();

        transmitals.sort((a, b) {
          return double.parse(b['docId']).compareTo(double.parse(a['docId']));
        });
        
        emit(TransmitalHistoryListLoaded(history: transmitals));
      } catch (e) {
        emit(TransmitalHistoryListStateError(error: e.toString()));
      }
    });
  }
}
