part of 'supplies_bloc.dart';

@immutable
sealed class SuppliesEvent {}

final class FetchSuppliesEvent extends SuppliesEvent{
  final String search;

  FetchSuppliesEvent({required this.search});
}
