part of 'office_supplies_bloc.dart';

@immutable
sealed class OfficeSuppliesState {}

final class OfficeSuppliesInitial extends OfficeSuppliesState {}

final class OfficeSuppliesLoading extends OfficeSuppliesState {}

class OfficeSuppliesLoaded extends OfficeSuppliesState {
  final List<Map<String, dynamic>> data;

  OfficeSuppliesLoaded(this.data);
}

class OfficeSuppliesStateError extends OfficeSuppliesState {
  final String error;

  OfficeSuppliesStateError(this.error);
}
