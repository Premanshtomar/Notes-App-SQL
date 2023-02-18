// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/services/auth/auth_exceptions.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc_events.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc_states.dart';
import 'package:untitled1/utils/dialog/loading_dialog.dart';
import 'package:untitled1/utils/dialog/show_dialogs.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool onChanged = false;
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

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
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is LoggedOutState) {
            final closeDialog = _closeDialogHandle;
            if (!state.isLoading && closeDialog != null) {
              closeDialog();
              _closeDialogHandle == null;
            } else if (state.isLoading && closeDialog == null) {
              _closeDialogHandle = showLoadingDialog(
                context: context,
                text: 'Loading...',
              );
            }

            if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(context, 'User Not Found');
            } else if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(context, 'Wrong Credentials');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, 'Authentication Error');
            }
          }
        },
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
                              onChanged = true;
                              await Future.delayed(const Duration(seconds: 1));
                              final email = _email.text.trim();
                              final password = _password.text;
                              // UserCredential? firebaseUser;
                              context.read<AuthBloc>().add(
                                    LoginEvent(
                                      email,
                                      password,
                                    ),
                                  );
                            },
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              width: onChanged
                                  ? 50
                                  : MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.11,
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
                            context.read<AuthBloc>().add(
                                  const ShouldRegisterEvent(),
                                );
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
      ),
    );
  }
}
