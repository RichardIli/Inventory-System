part of 'dashboard_users_count_bloc.dart';

@immutable
sealed class DashboardUsersCountState {}

final class DashboardUsersCountInitial extends DashboardUsersCountState {}

final class DashboardUsersCountLoading extends DashboardUsersCountState {}

final class DashboardUsersCountLoaded extends DashboardUsersCountState {
  final int count;

  DashboardUsersCountLoaded(this.count);
}

final class DashboardUsersCountError extends DashboardUsersCountState{
    final String error;

  DashboardUsersCountError(this.error);
}
