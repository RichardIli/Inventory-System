part of 'qr_generator_bloc.dart';

@immutable
sealed class QrGeneratorState {}

final class QrGeneratorInitial extends QrGeneratorState {}

final class QrGeneratorLoading extends QrGeneratorState{}

final class QrGeneratorLoaded extends QrGeneratorState{
  final Widget customQR;
  
  QrGeneratorLoaded(this.customQR);
}

final class QrGeneratorStateError extends QrGeneratorState{
  final String error;

  QrGeneratorStateError(this.error);
}