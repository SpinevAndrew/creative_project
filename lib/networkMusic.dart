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
  const NetworkMusicWidget({super.key});

  @override
  State<StatefulWidget> createState() => NetworkMusicState();
}

class NetworkMusicState extends State {

  final musicRef = FirebaseStorage.instance.ref().child("music/London.m4a");
  var url = "";
  final _player = AudioPlayer();
  // TODO Костыль
  LockCachingAudioSource _audioSource = LockCachingAudioSource(Uri.parse(""));

  @override
  void initState() {
    super.initState();
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
          title: const Text("Music"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(url),
                /*ElevatedButton(
                  child: Text(
                      _play ? "pause" : "play",
                  ),
                  onPressed: () {
                    setState(() {

                      if (_play) {
                        _player.play();
                      }
                      else{
                        _player.pause();
                      }
                      _play = !_play;
                    });
                  },
                ),

                ElevatedButton(
                  child: const Text('To 0'),
                  onPressed: () {
                    _player.seek(const Duration(seconds: 0));
                  },
                ),
                ElevatedButton(
                  child: const Text('ClearCache'),
                  onPressed: () {
                    _audioSource.clearCache();
                  },
                ),*/
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
                ElevatedButton(
                  child: const Text('ClearCache'),
                  onPressed: () {
                    _audioSource.clearCache();
                  },
                ),
              ],
            )
        )
    );
  }
}




