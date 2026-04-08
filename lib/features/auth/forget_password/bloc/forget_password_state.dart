part of 'forget_password_cubit.dart';

class ForgetPasswordState extends Equatable {
  final Status status;
  final String? errorMessage;
  final Failure? failure;

  const ForgetPasswordState(
      {this.status = Status.initial, this.errorMessage, this.failure});

  ForgetPasswordState copyWith({
    Status? status,
    String? errorMessage,
    Failure? failure,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, failure];
}
