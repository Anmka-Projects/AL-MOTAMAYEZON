part of 'contact_us_cubit.dart';

class ContactUsState extends Equatable {
  final Status status;
  final String? errorMessage;
  final Failure? failure;
  final String? message;

  const ContactUsState({
    this.status = Status.initial,
    this.errorMessage,
    this.failure,
    this.message,
  });

  ContactUsState copyWith({
    Status? status,
    String? errorMessage,
    Failure? failure,
    String? message,
  }) {
    return ContactUsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, failure, message];
} 