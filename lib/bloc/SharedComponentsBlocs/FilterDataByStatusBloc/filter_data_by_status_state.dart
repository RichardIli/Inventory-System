part of 'filter_data_by_status_bloc.dart';

@immutable
sealed class FilterDataByStatusState {}

final class FilterDataByStatusInitial extends FilterDataByStatusState {}

final class FilterDataByStatusLoading extends FilterDataByStatusState{}

final class FilterDataByStatusLoaded extends FilterDataByStatusState{
  final List<Map<String, dynamic>> storedToolsData, outSideToolsData;

  FilterDataByStatusLoaded({required this.storedToolsData,required this.outSideToolsData});
}

final class FilterDataByStatusStateError extends FilterDataByStatusState{
  final String error;

  FilterDataByStatusStateError({required this.error});
}