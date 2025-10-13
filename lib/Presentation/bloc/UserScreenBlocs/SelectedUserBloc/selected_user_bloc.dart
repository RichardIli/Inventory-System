import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';

part 'selected_user_event.dart';
part 'selected_user_state.dart';

class SelectedUserBloc extends Bloc<SelectedUserEvent, SelectedUserState> {
  SelectedUserBloc() : super(SelectedUserInitial()) {
    on<SelectSelectedUserEvent>((event, emit) {
      emit(SelectedUserLoading());
      try {
        final userData = event.userData;
        emit(SelectedUserLoaded(userData: userData));
      } catch (e) {
        emit(SelectedUserError(
            error:
                "Something went wrong while fetching the user's data\nError: $e"));
      }
    });
    
    on<ResetSelectedUserEvent>(
      (event, emit) => emit(SelectedUserInitial()),
    );
  }
}
