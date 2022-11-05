import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class LessonDate{
  String lessonName = "";
  String lessonPath = "";
  String lessonScript = "";

  LessonDate.fromMap(Map map){
    if (map.containsKey("lesson_name")){
      lessonName = map["lesson_name"];
    }
    if (map.containsKey("lesson_path")){
      lessonPath = map["lesson_path"];
    }
    if (map.containsKey("lesson_script")){
      lessonScript = map["lesson_script"];
    }
  }

}


class TasksListWidget extends StatefulWidget{
  const TasksListWidget({super.key});


  @override
  State<StatefulWidget> createState() => TaskListState();
}

class TaskListState extends State{

  Map<String, LessonDate> _data = {};
  String _keyEnabled = "1";

  @override
  void initState() {

    FirebaseFirestore.instance.collection("lessons").get().then(
            (value) =>
            {
              for (var doc in value.docs){
                _data.addAll({doc.id: LessonDate.fromMap(doc.data())})
              },
              setState(() {
                _data = _data;
              }),
            }
            );
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Music"),
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
                  enabled: int.parse(_keyEnabled) >= int.parse(key),
                  onTap: () {
                    print("hello $key");
                  },

                ),
              ],
            );
          }
        ),
    );
  }

}