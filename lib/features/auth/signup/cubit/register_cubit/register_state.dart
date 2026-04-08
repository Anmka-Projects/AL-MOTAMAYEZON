part of "register_cubit.dart";


class RegisterState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;

  const RegisterState(
      {this.status = Status.initial, this.failure, this.errorMessage});

  RegisterState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, failure, errorMessage];
}
