part of "verify_otp_bloc.dart";

class VerifyOTPState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;

  const VerifyOTPState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage,
  });

  VerifyOTPState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
  }) {
    return VerifyOTPState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, failure, errorMessage];
}