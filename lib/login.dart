import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'data.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});

  final LoginData _loginData = LoginData();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Login"),
        ),
        body: Center(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (inValue) {
                          if (inValue?.isEmpty ?? false) {
                            return "Please enter username";
                          }
                          return null;
                        },
                        onSaved: (inValue) {
                          _loginData.email = inValue!;
                        },
                        decoration: const InputDecoration(
                            hintText: "none@none.com",
                            labelText: "Username (E-mail address)"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (inValue) {
                          if (inValue?.isEmpty ?? false) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        onSaved: (inValue) {
                          _loginData.password = inValue!;
                        },
                        decoration: const InputDecoration(
                            hintText: "password", labelText: "Password"),
                      ),
                    ),
                    TextButton(
                        onPressed: () => {
                          Navigator.pushNamed(context, "/register")
                        },
                        child: const Text("Sign up")
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Try to sign in')
                              ),
                            );
                            try {
                               await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: _loginData.email,
                                  password: _loginData.password);
                            }
                            on FirebaseAuthException catch (e){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(e.message!),
                              ));
                            }
                            FirebaseAuth.instance.authStateChanges().listen((User? user) {
                              if (user != null){
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Hello ${user.displayName}!"),
                                ));
                                Navigator.pushReplacementNamed(context, "/tasks");
                              }
                            });
                          }
                        },
                        child: const Text("Login"))
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}