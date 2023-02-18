import 'package:untitled1/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState {
  const AuthState();
}

class LoggedInState extends AuthState {
  final AuthUser user;

  const LoggedInState(this.user);
}

class LoggedOutState extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;

  const LoggedOutState({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class VerificationState extends AuthState {
  const VerificationState();
}

class RegisterState extends AuthState {
  final Exception? exception;

  const RegisterState(this.exception);
}

class UninitializedState extends AuthState {
  const UninitializedState();
}
