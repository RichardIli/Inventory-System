import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'side_menu_event.dart';
part 'side_menu_state.dart';

class SideMenuBloc extends Bloc<SideMenuEvent, SideMenuState> {
  SideMenuBloc() : super(SideMenuState()) {
    on<NavigateToDashboardEvent>((event, emit) =>
        emit(SideMenuState(initialScreen: event.currentScreen)));
    on<NavigateToUsersEvent>((event, emit) =>
        emit(SideMenuState(initialScreen: event.currentScreen)));
    on<NavigateToToolsEquipmentsEvent>((event, emit) =>
        emit(SideMenuState(initialScreen: event.currentScreen)));
    on<NavigateToSuppliesEvent>((event, emit) =>
        emit(SideMenuState(initialScreen: event.currentScreen)));
    on<NavigateToOfficeSuppliesEvent>((event, emit) =>
        emit(SideMenuState(initialScreen: event.currentScreen)));
    on<NavigateToTransmitalHistoryEvent>((event, emit) =>
        emit(SideMenuState(initialScreen: event.currentScreen)));
  }
}
