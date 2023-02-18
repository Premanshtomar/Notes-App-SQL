// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:untitled1/firebase_options.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/services/auth/auth_exceptions.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc_events.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc_states.dart';
import 'package:untitled1/utils/dialog/show_dialogs.dart';

// import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
            image: AssetImage('asset/register.png'), fit: BoxFit.fill),
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is RegisterState) {
            if (state.exception is WeakPasswordAuthException) {
              await showErrorDialog(context, 'Password Is Too Weak');
            } else if (state.exception is UserNotFoundAuthException) {
              showErrorDialog(context, 'User Not Found');
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              showErrorDialog(context, 'Email Already In Use');
            } else if (state.exception is InvalidEmailAuthException) {
              showErrorDialog(context, 'Invalid Email');
            } else {
              showErrorDialog(context, 'Authentication Error');
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: MediaQuery.of(context).size.height * 0.05),
                  child: const Text(
                    'Create\nAccount...',
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )),
              SingleChildScrollView(
                child: Container(
                  // decoration: BoxDecoration(color: Colors.lightBlue),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.35,
                      left: 35,
                      right: 35,
                      bottom: MediaQuery.of(context).size.height * 0.35),
                  child: Column(
                    children: [
                      TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "example@xyz.com",
                          label: const Text(
                            'Email',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Enter your password',
                          label: const Text(
                            'Password',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Sign Up",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                                onPressed: () async {
                                  final email = _email.text;
                                  final password = _password.text;
                                  context.read<AuthBloc>().add(
                                        RegisterEvent(email, password),
                                      );
                                },
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                )),
                          )
                        ],
                      ),
                      // const SizedBox(
                      //   height: 100,
                      // ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.70,
                    left: MediaQuery.of(context).size.width * 0.05),
                child: TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const LogOutEvent(),
                        );
                  },
                  child: const Text("Sign In",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline)),
                ),
              )
            ],
          ),
        ),
      ),
    );
    // default; return const Text("Loading...");
  }
}
