part of 'save_qr_code_button_bloc.dart';

@immutable
sealed class SaveQrCodeButtonState {}

final class SaveQrCodeButtonInitial extends SaveQrCodeButtonState {}

final class SavingQrCodeButton extends SaveQrCodeButtonState{}

final class SavedQrCodeButton extends SaveQrCodeButtonState{
  final bool success;

  SavedQrCodeButton({required this.success});
}

final class SaveQrCodeButtonStateError extends SaveQrCodeButtonState{
  final String error;

  SaveQrCodeButtonStateError({required this.error});
}