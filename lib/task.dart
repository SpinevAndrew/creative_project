import 'package:flutter/material.dart';
import 'package:act_project/music.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key});

  @override
  State<StatefulWidget> createState() => TaskState();
}

class TaskState extends State {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Music"),
      ),
      body: const Text("Task"),
    );
  }
}