part of 'grade_submission_cubit.dart';

class GradeSubmissionState extends Equatable {
  final Status status;
  final String? errorMessage;
  final Failure? failure;
  final String? message;

  const GradeSubmissionState({
    this.status = Status.initial,
    this.errorMessage,
    this.failure,
    this.message,
  });

  GradeSubmissionState copyWith({
    Status? status,
    String? errorMessage,
    Failure? failure,
    String? message,
  }) {
    return GradeSubmissionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, failure, message];
} 