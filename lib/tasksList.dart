import 'dart:async';

import 'package:act_project/networkMusic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

class LessonDate {
  String lessonName = "";
  String lessonPath = "";
  String lessonScript = "";

  LessonDate.fromMap(Map map) {
    if (map.containsKey("lesson_name")) {
      lessonName = map["lesson_name"];
    }
    if (map.containsKey("lesson_path")) {
      lessonPath = map["lesson_path"];
    }
    if (map.containsKey("lesson_script")) {
      lessonScript = map["lesson_script"];
    }
  }
}

class LessonDataPass {
  LessonDate lesson;
  String index;
  int length;
  int maxAccessLesson;
  LessonDataPass(this.lesson, this.index, this.length, this.maxAccessLesson);


}

class TasksListWidget extends StatefulWidget {
  const TasksListWidget({super.key});

  @override
  State<StatefulWidget> createState() => TaskListState();
}

enum MenuItem{
  item1,
}

class TaskListState extends State {
  Map<String, LessonDate> _data = {};

  //String _keyEnabled = "1";
  int _currentLesson = 1;

  late StreamSubscription listener;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("lessons").get().then((value) => {
          for (var doc in value.docs)
            {
              _data.addAll({doc.id: LessonDate.fromMap(doc.data())})
            },
          setState(() {
            _data = _data;
          }),
        });
    int currentLesson;
    /*FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get().then(
          (value) => {
            currentLesson = value.data()!["current_lesson"],

            setState(() {
              _currentLesson = currentLesson;

            }),
          },
        );*/

    listener = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).snapshots().listen((event) {
      _currentLesson = event.data()!["current_lesson"];
      setState(() {
        _currentLesson = _currentLesson;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Tasks"),
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (value) async {
              if (value == MenuItem.item1){
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Good bye")));
                Navigator.pushReplacementNamed(context, "/login");
              }
            },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: MenuItem.item1,
                    child: Text("Sign out"),
                )
              ]
          )
        ],
      ),
      body: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            String key = _data.keys.elementAt(index);
            return Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.arrow_right),
                  title: Text("${_data[key]?.lessonName}"),
                  // CAREFUL TODO add check
                  //enabled: int.parse(_keyEnabled) >= int.parse(key),
                  enabled: _currentLesson >= int.parse(key),
                  onTap: () {
                    /*Navigator.pushNamed(
                        context,
                        "/networkMusic",
                        arguments: _data[key]);*/
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NetworkMusicWidget(lessonPass: LessonDataPass(_data[key]!, key.toString(), _data.length, _currentLesson))
                      )
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}
