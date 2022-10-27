import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App",
      initialRoute: "/",
      routes: {
        "/": (context) => EnterWidget(),
        "/login": (context) => LoginWidget(),
        "/register": (context) => RegisterWidget(),
      },
    );
  }
}

class EnterWidget extends StatelessWidget {
  const EnterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("MainPage"),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Text(
                "Hello",
                style: MyTextStyle,
              ),
            ),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
            ),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
            )
          ],
        ),
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});

  LoginData _loginData = new LoginData();
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Text("Hello", style: MyTextStyle),
              ),
              Form(
                key: this._formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (inValue) {
                          if (inValue?.length == 0) {
                            return "Please enter username";
                          }
                          return null;
                        },
                        onSaved: (inValue){
                          this._loginData.username = inValue!;
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
                          if (inValue?.length == 0) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        onSaved: (inValue){
                          this._loginData.password = inValue!;
                        },
                        decoration: const InputDecoration(
                            hintText: "password", labelText: "Password"),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Processing Data: ${_loginData.username} ${_loginData.password}')),
                            );
                          }
                        },
                        child: const Text("Login"))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class RegisterWidget extends StatelessWidget{
  final LoginData _loginData = LoginData();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Register"),
        ),
        body: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Text("Hello", style: MyTextStyle),
              ),
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
                          if (inValue?.length == 0) {
                            return "Please enter username";
                          }
                          return null;
                        },
                        onSaved: (inValue){
                          this._loginData.username = inValue!;
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
                          if (inValue?.length == 0) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        onSaved: (inValue){
                          this._loginData.password = inValue!;
                        },
                        decoration: const InputDecoration(
                            hintText: "password", labelText: "Password"),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Processing Data: ${_loginData.username} ${_loginData.password}')),
                            );
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


class LoginData {
  String username = "";
  String password = "";
}

const MyTextStyle = TextStyle(fontSize: 20.0, fontFamily: "Hind");
