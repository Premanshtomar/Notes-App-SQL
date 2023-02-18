import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class InitializeEvent extends AuthEvent {
  const InitializeEvent();
}


class ShouldRegisterEvent extends AuthEvent{
  const ShouldRegisterEvent();
}
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent(
    this.email,
    this.password,
  );
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  const RegisterEvent(
    this.email,
    this.password,
  );
}

class LogOutEvent extends AuthEvent {
  const LogOutEvent();
}
class SendVerificationMailEvent extends AuthEvent{
  const SendVerificationMailEvent();
}