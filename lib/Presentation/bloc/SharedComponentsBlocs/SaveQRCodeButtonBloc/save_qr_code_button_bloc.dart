import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Presentation/QRGeneratorCapture/qr_code_generator.dart';

part 'save_qr_code_button_event.dart';
part 'save_qr_code_button_state.dart';

class SaveQrCodeButtonBloc
    extends Bloc<SaveQrCodeButtonEvent, SaveQrCodeButtonState> {
  final QrCodeGeneratorRepository qrCodeGeneratorRepository;
  SaveQrCodeButtonBloc({required this.qrCodeGeneratorRepository})
      : super(SaveQrCodeButtonInitial()) {
    on<PressedSaveQrCodeButtonEvent>((event, emit) async {
      emit(SavingQrCodeButton());
      try {
        bool success = await qrCodeGeneratorRepository.captureAndSave(
            repaintBoundaryKey: event.repaintBoundaryKey,
            qrCodeName: event.qrCodeName);
        emit(SavedQrCodeButton(success: success));
      } catch (e) {
        emit(SaveQrCodeButtonStateError(error: e.toString()));
      }
    });

    on<ResetSaveQrCodeButtonEvent>(
      (event, emit) => emit(SaveQrCodeButtonInitial()),
    );
  }
}
