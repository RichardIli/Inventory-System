part of 'save_qr_code_button_bloc.dart';

@immutable
sealed class SaveQrCodeButtonEvent {}

final class PressedSaveQrCodeButtonEvent extends SaveQrCodeButtonEvent {
  final GlobalKey repaintBoundaryKey;
  final String qrCodeName;

  PressedSaveQrCodeButtonEvent(
      {required this.repaintBoundaryKey, required this.qrCodeName});
}

final class ResetSaveQrCodeButtonEvent extends SaveQrCodeButtonEvent {}
