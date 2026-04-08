part of 'support_whatsapp_cubit.dart';

class SupportWhatsappState extends Equatable {
  final Status status;
  final String? whatsappNumber;
  final String? errorMessage;
  final Failure? failure;
  final String? successMessage;

  const SupportWhatsappState({
    this.status = Status.initial,
    this.whatsappNumber,
    this.errorMessage,
    this.failure,
    this.successMessage,
  });

  SupportWhatsappState copyWith({
    Status? status,
    String? whatsappNumber,
    String? errorMessage,
    Failure? failure,
    String? successMessage,
  }) {
    return SupportWhatsappState(
      status: status ?? this.status,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, whatsappNumber, errorMessage, failure, successMessage];
}
