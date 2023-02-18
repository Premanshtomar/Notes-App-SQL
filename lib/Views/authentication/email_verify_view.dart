// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:untitled1/Views/show_dialogs.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc_events.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    // return
    return Scaffold(
        appBar: AppBar(title: const Text('Email verify')),
        body: Column(
          children: [
            const Text(
                "we've sent you a verification mail Please check your mail!! "),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const SendVerificationMailEvent(),
                      );
                },
                child: const Text('Click Here')),
            const Text("If you didn't received verification email."
                "Click button above to Send verification mail again"),
            const Text(
                "Once you verify your email click button bellow to login!"),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                    const LogOutEvent(),
                  );
                },
                child: const Text('Login'))
          ],
        ));
  }
}
