part of 'filter_data_by_status_bloc.dart';

@immutable
sealed class FilterDataByStatusEvent {}

final class FetchFilteredDataByStatusEvent extends FilterDataByStatusEvent {
  final String  nameToFilter;

  FetchFilteredDataByStatusEvent(
      { required this.nameToFilter});
}

