import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:act_project/string_duration.dart';
import 'package:flutter/services.dart';


class MusicWidget extends StatefulWidget {
  const MusicWidget({super.key});


  @override
  State<StatefulWidget> createState() => MusicState();
}

class MusicState extends State {
  final _keyButtonPlayMusic = GlobalKey<FormState>();
  bool _play = false;
  String _currentPosition = "";
  final String _nameMusic = "London";
  final String _nameFileWithMusic = "London.m4a";
  final String _nameFileWithScript = "London.txt";
  final dirScriptsPath = "assets/scripts";

  String _text = "";
  final _answerController = TextEditingController();

  //final _keyTextAnswer2 = GlobalKey<FormState>();
  // Number char in text
  final n = 10;
  final _answerController2 = TextEditingController();
  var _text1 = "";
  var _text2 = "";

  void _loadData() async {
    final fullPath = "$dirScriptsPath/$_nameFileWithScript";
    final loadedData = await rootBundle.loadString(fullPath);
    setState(() {
      _text = loadedData;
      _text1 = _text.substring(0, n);
      _text2 = _text.substring(n);
    });
  }
  @override
  void dispose() {
    _answerController2.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Music"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AudioWidget.assets(
              path: "assets/audio/$_nameFileWithMusic",
              play: _play,
              child: Column(
                children: [
                  Text(_nameMusic),
                  ElevatedButton(
                    key: _keyButtonPlayMusic,
                    child: Text(
                      _play ? "pause" : "play",
                    ),
                    onPressed: () {
                      setState(() {
                        _play = !_play;
                      });
                    },
                  ),
                  Text(_currentPosition),
                ],
              ),
              onFinished: () {
                setState(() {
                  _play = false;
                });
              },
              onReadyToPlay: (total) {
                setState(() {
                  _currentPosition =
                      '${const Duration().mmSSFormat} / ${total.mmSSFormat}';
                });
              },
              onPositionChanged: (current, total) {
                setState(() {
                  _currentPosition = '${current.mmSSFormat} / ${total.mmSSFormat}';
                });
              },
            ),
            Text(_text),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _answerController,

                decoration: const InputDecoration(
                  fillColor: Colors.white70,
                  filled: true,
                  isCollapsed: true,

                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  var flag = false;
                  if (_text == _answerController.value.text){
                    flag = true;
                  }
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(flag ? "Success" : "Failure")));
                },
                child: const Text("Check")
            ),
            Row(
              children: [
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  //maxLength: n,
                  //maxLengthEnforcement: MaxLengthEnforcement.none,
                  //initialValue: _text1,
                  controller: _answerController2,
                  decoration: const InputDecoration(
                    constraints: BoxConstraints(maxWidth: 100),
                    fillColor: Colors.white70,
                    filled: true,
                    isCollapsed: true,

                  ),
                ),
                Text(
                  _text2,
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  var flag = false;
                  if (_text1 == _answerController2.value.text){
                    flag = true;
                  }
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(flag ? "Success" : "Failure")));
                },
                child: const Text("Check")
            ),
          ],
        ),
      ),
    );
  }
}
