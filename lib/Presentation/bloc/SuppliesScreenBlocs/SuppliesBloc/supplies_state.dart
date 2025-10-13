part of 'supplies_bloc.dart';

@immutable
sealed class SuppliesState {}

final class SuppliesInitial extends SuppliesState {}

final class SuppliesLoading extends SuppliesState {}

class SuppliesLoaded extends SuppliesState {
  final List<Map<String, dynamic>> data;

  SuppliesLoaded(this.data);
}

class SuppliesStateError extends SuppliesState {
  final String error;

  SuppliesStateError(this.error);
}
