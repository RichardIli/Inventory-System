part of 'qr_generator_bloc.dart';

@immutable
sealed class QrGeneratorEvent {}

final class GenerateQREvent extends QrGeneratorEvent{
  final String itemID;
  final String itemName;

  GenerateQREvent({required this.itemID,required this.itemName});
}