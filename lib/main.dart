import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/Views/authentication/email_verify_view.dart';
import 'package:untitled1/Views/authentication/login_view.dart';
import 'package:untitled1/Views/authentication/register_view.dart';
import 'package:untitled1/Views/notes/add_or_update_note.dart';
import 'package:untitled1/Views/notes/notes_view.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc_events.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc_states.dart';
import 'package:untitled1/services/auth/firebase_auth_provider.dart';
import 'package:untitled1/utils/gradients/gradient_widget.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        appBarTheme:
            const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        '/notes/': (context) => const Notes(),
        '/add_new_note/': (context) => const AddOrUpdateNewNote(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const InitializeEvent());
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is LoggedInState) {
        return const Notes();
      } else if (state is VerificationState) {
        return const EmailVerification();
      }else if (state is RegisterState){
        return const RegisterView();
      } else if (state is LoggedOutState) {
        return const LoginView();
      } else {
        return const Scaffold(
          body: Center(child: GradientWidget(
            child: CircularProgressIndicator(
            ),
          )),
        );
      }
    });
  }
}
