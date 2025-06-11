part of 'side_menu_bloc.dart';

@immutable
sealed class SideMenuEvent {}

class NavigateToDashboardEvent extends SideMenuEvent {
  final int currentScreen;

  NavigateToDashboardEvent() : currentScreen = 0;
}

class NavigateToUsersEvent extends SideMenuEvent {
  final int currentScreen;

  NavigateToUsersEvent() : currentScreen = 1;
}

class NavigateToToolsEquipmentsEvent extends SideMenuEvent {
  final int currentScreen;

  NavigateToToolsEquipmentsEvent() : currentScreen = 2;
}

class NavigateToSuppliesEvent extends SideMenuEvent {
  final int currentScreen;

  NavigateToSuppliesEvent() : currentScreen = 3;
}

class NavigateToOfficeSuppliesEvent extends SideMenuEvent {
  final int currentScreen;

  NavigateToOfficeSuppliesEvent() : currentScreen = 4;
}

class NavigateToTransmitalHistoryEvent extends SideMenuEvent {
  final int currentScreen;

  NavigateToTransmitalHistoryEvent() : currentScreen = 5;
}
