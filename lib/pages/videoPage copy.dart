import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:tv_app/components/topbar.dart';
import 'package:tv_app/components/sidenavbar.dart';

class VideoPage extends StatefulWidget {
  const VideoPage(
      {required Key? key, required this.title, required this.streamingLink})
      : super(key: key);

  final String streamingLink;
  final String title;

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VlcPlayerController _controller;
  bool _isPlaying = true;
  double _volume = 100.0;
  double _position = 0.0;
  bool _isFullScreen = false;
  Duration _duration = const Duration();
  Orientation currentOrientation = Orientation.portrait;

  @override
  void initState() {
    super.initState();
    _controller = VlcPlayerController.network(widget.streamingLink);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _stop() {
    _controller.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void _seek(double position) {
    _controller.setTime(position.toInt());
  }

  void _setVolume(double volume) {
    _controller.setVolume(volume.toInt());
    setState(() {
      _volume = volume;
    });
  }

  void _toggleFullScreen() {
    if (_isFullScreen) {
      setState(() {
        _isFullScreen = !_isFullScreen;
      });
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    } else {
      setState(() {
        _isFullScreen = !_isFullScreen;
      });
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff27A0C6),
          elevation: 0,
          // title: Text(widget.title),

          title: Text(IsPortrait.isPortrait.toString()),
        ),
        drawer: Drawer(
          child: DrawerNav(),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
                child: Stack(children: [
              if (!_isFullScreen && !IsPortrait.isPortrait) ...[
                Text(IsPortrait.isPortrait.toString()),
                VlcPlayer(
                  controller: _controller,
                  aspectRatio: 1, // Adjust the aspect ratio as needed
                  placeholder: const Center(child: CircularProgressIndicator()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: _playPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: _stop,
                    ),
                    Slider(
                      value: _volume,
                      min: 0.0,
                      max: 100.0,
                      onChanged: _setVolume,
                    ),
                    IconButton(
                      icon: Icon(_isFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen),
                      onPressed: _toggleFullScreen,
                    ),
                  ],
                ),
              ] else if (_isFullScreen && IsPortrait.isPortrait) ...[
                Row(
                  children: [
                    Text(IsPortrait.isPortrait.toString()),
                    VlcPlayer(
                      controller: _controller,
                      aspectRatio: 3, // Adjust the aspect ratio as needed
                      placeholder:
                          const Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: _playPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: _stop,
                  ),
                  Slider(
                    value: _volume,
                    min: 0.0,
                    max: 100.0,
                    onChanged: _setVolume,
                  ),
                  IconButton(
                    icon: Icon(_isFullScreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen),
                    onPressed: _toggleFullScreen,
                  ),
                ])
              ]
            ]))
          ]);
        }));
  }
}

class IsPortrait {
  static bool isPortrait = true;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      isPortrait = true;
    } else {
      isPortrait = false;
    }
  }
}
