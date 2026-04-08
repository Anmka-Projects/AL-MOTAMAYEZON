part of 'stages_grades_cubit.dart';


class StagesGradesState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;

  const StagesGradesState({this.status = Status.initial, this.failure, this.errorMessage});

  StagesGradesState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
  }) {
    return StagesGradesState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, failure, errorMessage];
}
