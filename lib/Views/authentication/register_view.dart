// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:untitled1/firebase_options.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/utils/show_dialogs.dart';
import 'package:untitled1/services/auth/auth_exceptions.dart';
import 'package:untitled1/services/auth/auth_services.dart';

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
                            borderSide: const BorderSide(color: Colors.white)),
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
                            borderSide: const BorderSide(color: Colors.white)),
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
                                try {
                                  await AuthServices.firebase().createUser(
                                      email: email, password: password);
                                  AuthServices.firebase()
                                      .sendEmailVerification();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context)
                                      .pushNamed('/email_verify/');
                                } on WeakPasswordAuthException catch (_) {
                                  showErrorDialog(
                                      context, 'Password Is Too Weak');
                                } on UserNotFoundAuthException catch (e) {
                                  showErrorDialog(context, e.toString());
                                } on EmailAlreadyInUseAuthException catch (_) {
                                  showErrorDialog(
                                      context, 'Email Already In Use.');
                                } on InvalidEmailAuthException catch (_) {
                                  showErrorDialog(context, 'Invalid Email');
                                } on GenericAuthException catch (_) {
                                  showErrorDialog(
                                      context, 'Authentication Error.');
                                }
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
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.70,left: MediaQuery.of(context).size.width*0.05),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/', (route) => false);
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
    );
    // default; return const Text("Loading...");
  }
}
