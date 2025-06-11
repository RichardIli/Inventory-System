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
    on<FetchTransmitalHistoryListEvent>((event, emit)  {
      emit(TransmitalHistoryListLoading());
      try {
        final transmitals =
             transmitalHistoryRepo.fetchTransmitalHistory();
        emit(TransmitalHistoryListLoaded(history: transmitals));
      } catch (e) {
        emit(TransmitalHistoryListStateError(error: e.toString()));
      }
    });
  }
}
