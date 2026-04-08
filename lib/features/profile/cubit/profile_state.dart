part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final Status status;
  final String? errorMessage;
  final Failure? failure;
  final ProfileModel? profile;
  final String? message;

  const ProfileState({
    this.status = Status.initial,
    this.errorMessage,
    this.failure,
    this.profile,
    this.message,
  });

  ProfileState copyWith({
    Status? status,
    String? errorMessage,
    Failure? failure,
    ProfileModel? profile,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      profile: profile ?? this.profile,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, failure, profile, message];
} 