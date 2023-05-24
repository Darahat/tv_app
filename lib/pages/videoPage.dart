import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:tv_app/pages/tv_list.dart';

class VideoPage extends StatefulWidget {
  final String streamingLink;

  VideoPage(this.streamingLink);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VlcPlayerController _controller;
  bool _isPlaying = false;
  double _volume = 100.0;
  double _position = 0.0;
  bool _isFullScreen = false;
  Duration _duration = Duration();

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
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VLC Player'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                VlcPlayer(
                  controller: _controller,
                  aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                  placeholder: Center(child: CircularProgressIndicator()),
                ),
                if (_isFullScreen)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _toggleFullScreen,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _playPause,
              ),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: _stop,
              ),
              Slider(
                value: _position,
                min: 0.0,
                max: _duration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _position = value;
                  });
                },
                onChangeEnd: _seek,
              ),
              IconButton(
                icon: Icon(
                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                onPressed: _toggleFullScreen,
              ),
            ],
          ),
          Slider(
            value: _volume,
            min: 0.0,
            max: 100.0,
            onChanged: _setVolume,
          ),
        ],
      ),
    );
  }
}
