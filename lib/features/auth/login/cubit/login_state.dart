part of 'login_cubit.dart';

class LoginState extends Equatable {
  final Status status;
  final String? errorMessage;
  final Failure? failure;

  const LoginState(
      {this.status = Status.initial, this.errorMessage, this.failure});

  LoginState copyWith({
    Status? status,
    String? errorMessage,
    Failure? failure,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, failure];
}
