part of 'students_cubit.dart';

class StudentsState extends Equatable {
  final Status status;
  final String? errorMessage;
  final Failure? failure;

  const StudentsState(
      {this.status = Status.initial, this.errorMessage, this.failure});

  StudentsState copyWith({
    Status? status,
    String? errorMessage,
    Failure? failure,
  }) {
    return StudentsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, failure];
}