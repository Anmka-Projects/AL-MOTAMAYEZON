part of 'reset_password_cubit.dart';

class ResetPasswordState extends Equatable {
  final Status status;
  final String? errorMessage;
  final Failure? failure;

  const ResetPasswordState(
      {this.status = Status.initial, this.errorMessage, this.failure});

  ResetPasswordState copyWith({
    Status? status,
    String? errorMessage,
    Failure? failure,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, failure];
}
