// import 'package:untitled1/firebase_options.dart';
import 'package:untitled1/services/auth/auth_provider.dart';
import 'package:untitled1/services/auth/auth_user.dart';
import 'package:untitled1/services/auth/firebase_auth_provider.dart';
// import 'package:firebase_core/firebase_core.dart';


class AuthServices implements AuthProvider {
  final AuthProvider provider;

  const AuthServices(this.provider);

  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required email,
    required password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required email,
    required password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
