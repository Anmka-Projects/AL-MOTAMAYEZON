part of 'logout_cubit.dart';

class LogoutState extends Equatable {
  final Status status;
  final String? errorMessage;
  final Failure? failure;

  const LogoutState({this.status = Status.initial, this.errorMessage, this.failure});

  LogoutState copyWith({
    Status? status,
    String? errorMessage,
    Failure? failure,
  }) {
    return LogoutState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, failure];
} 