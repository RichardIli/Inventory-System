part of 'office_supplies_bloc.dart';

@immutable
sealed class OfficeSuppliesEvent {}

final class FetchOfficeSuppliesEvent extends OfficeSuppliesEvent{
  final String search;

  FetchOfficeSuppliesEvent({required this.search});
}
