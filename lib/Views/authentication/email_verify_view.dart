// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:untitled1/Views/show_dialogs.dart';
import 'package:untitled1/services/auth/auth_services.dart';

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
        body:Column(
          children: [
            const Text("we've sent you a verification mail Please check your mail!! "),
            TextButton(
                onPressed: () async {
                  await AuthServices.firebase().sendEmailVerification();
                },
                child: const Text('Click Here')),
            const Text("If you didn't received verification email."
                "Click button above to Send verification mail again"),

            const Text("Once you verify your email click button bellow to login!"),
            TextButton(onPressed: () async{
                await AuthServices.firebase().logOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
            },
                child: const Text('Login'))
          ],
        ));
  }
}
