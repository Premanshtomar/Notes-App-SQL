import 'package:test/test.dart';
import 'package:untitled1/services/auth/auth_exceptions.dart';
import 'package:untitled1/services/auth/auth_provider.dart';
import 'package:untitled1/services/auth/auth_user.dart';

void main() {
  group("Testing Mock provider", () {
    final provider = AuthMockProvider();
    test("Should Not Initialize to Begin With", () {
      expect(provider._isInitialized, false);
    });
    test("can not logout without Initialize", (){
      expect(provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test('Should be able to initialize', () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    });
    
    test("User should be null after initialization", () {
      expect(provider.currentUser, null);
    }
    );
    test("Should be able to initialize in less than 2 sec", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    },
        timeout: const Timeout(Duration(seconds: 2))
    );
    test("create user should d delegate login function", () async{
      final badEmailUser = provider.logIn(
        email: "prem@gmail.com",
        password: "hello",
      );
      expect(badEmailUser, 
          throwsA(
          const TypeMatcher<UserNotFoundAuthException>())
      );
      final badPassword = provider.createUser(email: 'prem@gmail.com', password: 'hello');
      expect(badPassword, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('loggedIn user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
    
    
  });
}

class NotInitializedException implements Exception {}

class AuthMockProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required email,
    required password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async{
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;

  }

  @override
  Future<AuthUser> logIn({
    required email,
    required password,
  }) {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'prem@gmail.com') throw UserNotFoundAuthException();
    if (password == 'hello') throw WrongPasswordAuthException();
    var user = AuthUser(isEmailVerified: false, email: 'prem@gmail.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async{
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();

    await Future.delayed(const Duration(seconds: 1));
    _user = null;
    }

  @override
  Future<void> sendEmailVerification() async{
    if (!_isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    var newUser = AuthUser(isEmailVerified: true, email: 'prem@gmail.com');
    _user = newUser;
  }
}
