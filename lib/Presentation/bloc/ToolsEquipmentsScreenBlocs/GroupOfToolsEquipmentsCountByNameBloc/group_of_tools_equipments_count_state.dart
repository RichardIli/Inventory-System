part of 'group_of_tools_equipments_count_bloc.dart';

@immutable
sealed class GroupOfToolsEquipmentsCountByNameState {}

final class GroupOfToolsEquipmentsCountByNameInitial extends GroupOfToolsEquipmentsCountByNameState {}

final class GroupOfToolsEquipmentsCountByNameLoading extends GroupOfToolsEquipmentsCountByNameState {
  final Widget loading;

  GroupOfToolsEquipmentsCountByNameLoading(this.loading);
}

final class GroupOfToolsEquipmentsCountByNameLoaded extends GroupOfToolsEquipmentsCountByNameState {
  final List<Map<String, dynamic>> datas;

  GroupOfToolsEquipmentsCountByNameLoaded(this.datas);
}

final class GroupOfToolsEquipmentsCountByNameStateError extends GroupOfToolsEquipmentsCountByNameState {
  final String error;

  GroupOfToolsEquipmentsCountByNameStateError(this.error);
}
