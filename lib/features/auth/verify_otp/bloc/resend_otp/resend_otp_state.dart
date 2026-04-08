part of 'resend_otp_cubit.dart';

class ResendOtpState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;

  const ResendOtpState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage,
  });

  ResendOtpState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
  }) {
    return ResendOtpState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, failure, errorMessage];
}
