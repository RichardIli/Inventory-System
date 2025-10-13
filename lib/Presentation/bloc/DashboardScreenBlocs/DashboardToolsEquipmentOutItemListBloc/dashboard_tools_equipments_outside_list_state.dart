part of 'dashboard_tools_equipments_outside_list_bloc.dart';

@immutable
sealed class DashboardToolsEquipmentsOutsideListState {}

final class DashboardToolsEquipmentsOutsideListInitial
    extends DashboardToolsEquipmentsOutsideListState {}

final class DashboardToolsEquipmentsOutsideListLoading
    extends DashboardToolsEquipmentsOutsideListState {}

final class DashboardToolsEquipmentsOutsideListLoaded
    extends DashboardToolsEquipmentsOutsideListState {
  final List<Map<String, dynamic>> data;

  DashboardToolsEquipmentsOutsideListLoaded(this.data);
}

final class DashboardToolsEquipmentsOutsideListError
    extends DashboardToolsEquipmentsOutsideListState {
  final String error;

  DashboardToolsEquipmentsOutsideListError(this.error);
}
