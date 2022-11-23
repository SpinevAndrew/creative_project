import 'package:act_project/tasksList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:act_project/SeekBar.dart';

import 'package:firebase_storage/firebase_storage.dart';

class PositionData{
  Duration? position;
  Duration? bufferedPosition;
  Duration? duration;
  PositionData(this.position, this.bufferedPosition, this.duration);

}

class NetworkMusicWidget extends StatefulWidget {
  LessonDataPass lessonPass;
  NetworkMusicWidget({required this.lessonPass, super.key});

  @override
  State<NetworkMusicWidget> createState() => NetworkMusicState();
}

class NetworkMusicState extends State<NetworkMusicWidget> {


  var musicRef = FirebaseStorage.instance.ref().child("");
  var url = "";
  final _player = AudioPlayer();
  TextEditingController _answerController = TextEditingController();
  var _text = "";
  String index = "";
  String _title = "Lesson";
  // TODO Костыль
  LockCachingAudioSource _audioSource = LockCachingAudioSource(Uri.parse(""));


  @override
  void initState() {

    super.initState();
    //print('!!!!!!!${widget.lesson}');
    musicRef = FirebaseStorage.instance.ref().child(widget.lessonPass.lesson.lessonPath);
    _text = widget.lessonPass.lesson.lessonScript;
    _title = widget.lessonPass.lesson.lessonName;
    index = widget.lessonPass.index;

    musicRef.getDownloadURL().then((value) => {
          setState(() {
            url = value;
            _audioSource = LockCachingAudioSource(Uri.parse(url));
            _player.setAudioSource(_audioSource);
          })
        });
  }


  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, double, Duration?, PositionData>(
          _player.positionStream,
          _audioSource.downloadProgressStream,
          _player.durationStream,
              (position, downloadProgress, reportedDuration) {
            final duration = reportedDuration ?? Duration.zero;
            final bufferedPosition = duration * downloadProgress;
            return PositionData(position, bufferedPosition, duration);
          });



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                //Text(url),

                StreamBuilder<PlayerState>(
                  stream: _player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 64.0,
                        height: 64.0,
                        child: const CircularProgressIndicator(),
                      );
                    } else if (playing != true) {
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 64.0,
                        onPressed: _player.play,
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        iconSize: 64.0,
                        onPressed: _player.pause,
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 64.0,
                        onPressed: () => _player.seek(Duration.zero),
                      );
                    }
                  },
                ),
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: _player.seek,
                    );
                  },
                ),
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
                      print(_answerController.value.text);
                      print(_text);
                      print(_answerController.value.text.codeUnits);
                      print(_text.codeUnits);
                      print(_answerController.value.text.compareTo(_text));
                      if (_text == _answerController.value.text){
                        flag = true;
                        _answerController.text = "";
                      }
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(flag ? "Success" : "Failure")));

                      if (flag) {
                        String new_index = (int.parse(index) + 1).toString();


                        if (int.parse(new_index) <= widget.lessonPass.length) {
                          // Paste new task
                          setState(() {
                            LessonDate lesson;
                            FirebaseFirestore.instance.collection("lessons")
                                .doc(new_index).get()
                                .then((value) =>
                            {
                              lesson = LessonDate.fromMap(value.data()!),
                              musicRef = FirebaseStorage.instance.ref().child(
                                  lesson.lessonPath),
                              _text = lesson.lessonScript,
                              _title = lesson.lessonName,
                              index = new_index,
                              musicRef.getDownloadURL().then((value) =>
                              {
                                url = value,
                                _audioSource =
                                    LockCachingAudioSource(Uri.parse(url)),
                                _player.setAudioSource(_audioSource)
                              }
                              ),
                            });
                          });
                          setState(() {
                            _title = "Lesson_$new_index";
                          });
                          if (widget.lessonPass.maxAccessLesson <=
                              int.parse(widget.lessonPass.index)) {
                            FirebaseFirestore.instance.collection("users").doc(
                                FirebaseAuth.instance.currentUser?.uid).update(
                                {"current_lesson": int.parse(new_index)}
                            );
                          }
                        }

                      else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("You compiled all tasks")));
                        Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("Check")
                ),
                /*ElevatedButton(
                  child: const Text('ClearCache'),
                  onPressed: () {
                    _audioSource.clearCache();
                  },
                ),*/
              ],
            )
        )
    );
  }
}




