import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';

part 'selected_item_event.dart';
part 'selected_item_state.dart';

class SelectedItemBloc extends Bloc<SelectedItemEvent, SelectedItemState> {
  SelectedItemBloc() : super(SelectedItemInitial()) {
    on<SelectSelectedItemEvent>((event, emit) {
      emit(SelectedItemLoading());
      try {
        final passedData = event.passedData;
        emit(SelectedItemLoaded(passedData: passedData));
      } catch (e) {
        emit(SelectedItemError(error: "Error message: $e"));
      }
    });
  }
}
