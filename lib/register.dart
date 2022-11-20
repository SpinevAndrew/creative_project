import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterData {
  String username = "";
  String email = "";
  String password = "";
  String? confirmPassword = "";

  RegisterData();
  RegisterData.fromDb(this.username, this.email, this.password);

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'username': username,
  };

  static RegisterData fromJson(Map<String, dynamic> json) => RegisterData.fromDb(
    json["username"],
    json["email"],
    json["password"]
  );

}


class RegisterWidget extends StatefulWidget{
  const RegisterWidget({super.key});

  @override
  State<StatefulWidget> createState() => RegisterState();
}



class RegisterState extends State {

  final RegisterData _registerData = RegisterData();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool emailDuplicate = false;


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Register"),
        ),
        body: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      child: Text("Hello"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _usernameController,
                        validator: (inValue) {
                          if (inValue?.isEmpty ?? false) {
                            return "Please enter username";
                          }
                          return null;
                        },
                        onSaved: (inValue) {
                          _registerData.username = inValue!;
                        },
                        decoration: const InputDecoration(
                            hintText: "JackSparrow",
                            labelText: "Username"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (inValue) {
                          if (inValue?.isEmpty ?? false) {
                            return "Please enter email";
                          }


                          if (emailDuplicate){
                            emailDuplicate = false;
                            return "Duplicate email";
                          }
                          return null;
                        },
                        onSaved: (inValue) {
                          _registerData.email = inValue!;
                        },
                        decoration: const InputDecoration(
                            hintText: "none@none.com",
                            labelText: "E-mail address"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        validator: (inValue) {
                          if (inValue?.isEmpty ?? false) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        onSaved: (inValue) {
                          _registerData.password = inValue!;
                        },
                        decoration: const InputDecoration(
                            hintText: "password", labelText: "Password"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _confirmPasswordController,
                        validator: (inValue) {
                          if (inValue?.isEmpty ?? false) {
                            return "Please enter password";
                          }
                          else{
                            if (inValue != _passwordController.value.text){
                              return "Passwords don't match";
                            }
                          }
                          return null;
                        },
                        onSaved: (inValue) {
                          _registerData.confirmPassword = inValue!;
                        },
                        decoration: const InputDecoration(
                            hintText: "password",
                            labelText: "Confirm password"),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Process save data"),
                            ));

                            await saveUser(_registerData);

                            FirebaseAuth.instance.authStateChanges().listen((User? user) {
                              if (user != null){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Hello ${user.displayName}!"),
                                ));
                                Navigator.pop(context);
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
        );
  }

  Future saveUser(RegisterData registerData) async {

    final email = registerData.email;
    final password = _registerData.password;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
     await FirebaseAuth.instance.currentUser?.updateDisplayName(registerData.username);
     FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser?.uid}").set(
        {"currentLesson": 1}
     );

    }
    on FirebaseAuthException catch (e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message!),
        ));
    }

  }
}
