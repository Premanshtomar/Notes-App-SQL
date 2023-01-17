// import 'package:firebase_core/firebase_core.dart';
// import 'package:untitled1/firebase_options.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:untitled1/utils/show_dialogs.dart';
import 'package:untitled1/services/auth/auth_exceptions.dart';
import 'package:untitled1/services/auth/auth_services.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool onChanged = false;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asset/login.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.19,
                    left: MediaQuery.of(context).size.width * 0.09),
                child: const Text(
                  'Welcome\n User...',
                  style: TextStyle(color: Colors.white, fontSize: 55),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2,
                    right: 35,
                    left: 35),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                            hintText: "example@xyz.com",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            fillColor: Colors.grey.shade300,
                            filled: true,
                            label: const Text("Email")),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            hintText: 'Enter your Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            fillColor: Colors.grey.shade300,
                            filled: true,
                            label: const Text('Password')),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Material(
                        color: Colors.lightBlue.shade200,
                        borderRadius:
                            BorderRadius.circular(onChanged ? 150 : 10),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              onChanged = true;
                            });
                            await Future.delayed(
                                const Duration(seconds: 1));
                            final email = _email.text.trim();
                            final password = _password.text;
                            // UserCredential? firebaseUser;
                            try {
                              await AuthServices.firebase()
                                  .logIn(email: email, password: password);
                              if (AuthServices.firebase()
                                      .currentUser
                                      ?.isEmailVerified ??
                                  false) {
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil(
                                        '/notes/', (route) => false);
                              } else {
                                await AuthServices.firebase()
                                    .sendEmailVerification();
                                Navigator.of(context)
                                    .pushNamed('/email_verify/');
                              }
                            } on UserNotFoundAuthException catch (_) {
                              showErrorDialog(context, 'User Not Found.');
                            } on WrongPasswordAuthException catch (_) {
                              showErrorDialog(context, 'Wrong Password.');
                            } on InvalidEmailAuthException catch (_) {
                              showErrorDialog(context, 'Invalid Email');
                            } on GenericAuthException catch (_) {
                              showErrorDialog(
                                  context, 'Authentication Error.');
                            }
                            setState(() {
                              onChanged = false;
                            });
                          },
                          child: AnimatedContainer(
                            alignment: Alignment.center,
                            width: onChanged
                                ? 50
                                : MediaQuery.of(context).size.width * 0.4,
                            height:
                                MediaQuery.of(context).size.width * 0.11,
                            duration: const Duration(seconds: 1),
                            child: onChanged
                                ? const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register/');
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Color(0xff4c505b)),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
