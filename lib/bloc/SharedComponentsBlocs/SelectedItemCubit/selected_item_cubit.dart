import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'selected_item_state.dart';

class SelectedItemCubit extends Cubit<SelectedItemState> {
  SelectedItemCubit() : super(SelectedItem(passedData: {}));

  void setSelectedItem({required Map<String, dynamic> passedData}) =>
      emit(SelectedItem(passedData: passedData));
}
