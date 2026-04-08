part of 'social_auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class LoginInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginErrorState extends AuthState {
  final String message;

  const LoginErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class SignupLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class SignupSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

class SignupErrorState extends AuthState {
  final String message;

  const SignupErrorState(this.message);

  @override
  List<Object> get props => [message];
}