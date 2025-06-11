import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/QRGeneratorCapture/qr_code_generator.dart';

part 'qr_generator_event.dart';
part 'qr_generator_state.dart';

class QrGeneratorBloc extends Bloc<QrGeneratorEvent, QrGeneratorState> {
  final QrCodeGeneratorRepository generator;
  QrGeneratorBloc(this.generator) : super(QrGeneratorInitial()) {
    on<GenerateQREvent>((event, emit) {
      emit(QrGeneratorLoading());
      try {
        final Widget qr= generator.generateItemQRCode(event.itemID, event.itemName);
        emit(QrGeneratorLoaded(qr));
      } catch (e) {
        emit(QrGeneratorStateError(e.toString()));
      }
    });
  }
}
