// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:untitled1/services/auth/auth_provider.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc_events.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const UninitializedState()) {
    on<SendVerificationMailEvent>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    //Initialize
    on<InitializeEvent>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const LoggedOutState(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const VerificationState());
      } else {
        emit(LoggedInState(user));
      }
    });
    on<LoginEvent>((event, state) async {
      emit(
        const LoggedOutState(
          exception: null,
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(
            const LoggedOutState(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const VerificationState());
        } else {
          emit(
            const LoggedOutState(
              exception: null,
              isLoading: false,
            ),
          );
          emit(LoggedInState(user));
        }
      } on Exception catch (e) {
        emit(
          LoggedOutState(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    on<LogOutEvent>((event, state) async {
      try {
        provider.logOut();
        emit(
          const LoggedOutState(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          LoggedOutState(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    on<RegisterEvent>((event, state) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();

        emit(const VerificationState());
      } on Exception catch (e) {
        emit(RegisterState(e));
      }
    });
    on<ShouldRegisterEvent>((event, emit){
      emit(const RegisterState(null));
    });
  }
}
