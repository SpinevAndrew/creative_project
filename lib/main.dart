import 'package:act_project/register.dart';
import 'package:act_project/data.dart';
import 'package:act_project/login.dart';
import 'package:act_project/music.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

/*void main() {
  runApp(MyApp());
}*/

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "App",
      initialRoute: "/",
      routes: {
        "/": (context) => const EnterWidget(),
        "/login": (context) => LoginWidget(),
        "/register": (context) => const RegisterWidget(),
        "/music": (context) => MusicWidget(),
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
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("USER:::\t${FirebaseAuth.instance.currentUser?.email ?? "No auth"}"),
                  ));
                },
                child: const Text("Sign out")
            ),
            ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("USER:::\t${FirebaseAuth.instance.currentUser?.displayName ?? "No auth"}"),
                  ));
                },
                child: const Text("Info user")
            ),
            ElevatedButton(
              child: const Text('Music'),
              onPressed: () {
                Navigator.pushNamed(context, "/music");
              },
            ),
          ],
        ),
      ),
    );
  }

}




