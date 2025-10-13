part of 'transmital_history_list_bloc.dart';

@immutable
sealed class TransmitalHistoryListState {}

final class TransmitalHistoryListInitial extends TransmitalHistoryListState {}

final class TransmitalHistoryListLoading extends TransmitalHistoryListState {}

final class TransmitalHistoryListLoaded extends TransmitalHistoryListState {
  final List history;

  TransmitalHistoryListLoaded({required this.history});
}

final class TransmitalHistoryListStateError extends TransmitalHistoryListState {
  final String error;

  TransmitalHistoryListStateError({required this.error});
}
