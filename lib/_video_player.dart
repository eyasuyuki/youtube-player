import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';

import 'l10n/app_localizations.dart';

class VideoPlayer extends StatefulWidget {
  final videoId;
  VideoPlayer({this.videoId});

  @override
  _VideoPlayerState createState() => new _VideoPlayerState(videoId: videoId);
}

class _VideoPlayerState extends State<VideoPlayer>
    implements YouTubePlayerListener {
  final videoId;
  String _playerState = "";
  double _currentVideoSecond = 0.0;

  _VideoPlayerState({this.videoId});

  FlutterYoutubeViewController _controller;

  void _onYoutubeCreated(FlutterYoutubeViewController controller) {
    this._controller = controller;
  }

  @override
  void onReady() {
    print('_VideoPlayerState: onReady'); //TODO debug
  }

  @override
  void onStateChange(String state) {
    print('_VideoPlayerState: onStateChange: state=$state'); //TODO debug
    setState(() {
      _playerState = state;
    });
  }

  @override
  void onError(String error) {
    print('_VideoPlayerState: onError: error=$error'); //TODO debug
  }

  @override
  void onVideoDuration(double duration) {
    print(
        '_VideoPlayerState: onVideoDuration: duration=$duration'); //TODO debug
  }

  @override
  void onCurrentSecond(double second) {
    print('_VideoPlayerState: onCurrentSecond: second=$second'); //TODO debug
    _currentVideoSecond = second;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).title),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: FlutterYoutubeView(
              onViewCreated: _onYoutubeCreated,
              listener: this,
              params: YoutubeParam(
                  videoId: videoId, showUI: true, startSeconds: 0.0),
            ),
          ),
        ],
      ),
    );
  }
}
