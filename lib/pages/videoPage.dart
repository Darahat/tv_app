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
  bool _showBars = false;
  Duration _duration = const Duration();

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
    _showBarFunction();
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    ;

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _stop() {
    _showBarFunction();

    _controller.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void _seek(double position) {
    _controller.setTime(position.toInt());
  }

  void _showBarFunction() {
    setState(() {
      if (_showBars == true) {
        _showBars = false;
      } else {
        _showBars = true;
      }
    });
  }

  void _setVolume(double volume) {
    _controller.setVolume(volume.toInt());
    setState(() {
      _volume = volume;
    });
  }

  String _showBarsText() {
    if (_showBars) {
      return 'True';
    } else {
      return 'false';
    }
  }

  void _toggleFullScreen() {
    _showBarFunction();

    if (_isFullScreen) {
      setState(() {
        _isFullScreen = !_isFullScreen;
      });
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    } else {
      setState(() {
        _isFullScreen = !_isFullScreen;
      });
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.popUntil(context, ModalRoute.withName('/'));
          return true;
        },
        child: Scaffold(
          appBar: _showBars
              ? null
              : AppBar(
                  backgroundColor: Color(0xff27A0C6),
                  elevation: 0,
                  // title: Text(widget.title),
                  title: Text(_showBarsText()),
                ),
          drawer: Drawer(
            child: DrawerNav(),
          ),
          body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _playPause();
              },
              child: IgnorePointer(
                  child: Column(
                children: [
                  // FloatingActionButton(
                  //   onPressed: () {
                  //     // Add your onPressed code here!
                  //     _toggleFullScreen();
                  //   },
                  //   backgroundColor: Colors.green,
                  //   child: const Icon(Icons.fullscreen_exit),
                  // ),
                  Expanded(
                    child: OrientationBuilder(
                      builder: (context, orientation) {
                        final isPortrait = orientation == Orientation.portrait;
                        return
                            // children: [
                            Container(
                          height: isPortrait
                              ? MediaQuery.of(context).size.height * 0.8
                              : MediaQuery.of(context).size.height,
                          child: VlcPlayer(
                            controller: _controller,
                            aspectRatio: isPortrait
                                ? 16 / 9
                                : 3, // Adjust the aspect ratio as needed
                            placeholder: const Center(
                                child: CircularProgressIndicator()),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ))),
          bottomNavigationBar: _showBars
              ? null
              : BottomNavigationBar(
                  // fixedColor: Colors.amber,
                  items: [
                    BottomNavigationBarItem(
                      backgroundColor: Colors.blue,
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      label: _isPlaying ? 'Pause' : 'Play',
                    ),
                    const BottomNavigationBarItem(
                      backgroundColor: Colors.blue,
                      icon: Icon(Icons.stop),
                      label: 'Stop',
                    ),
                    BottomNavigationBarItem(
                      backgroundColor: Colors.blue,
                      icon: Icon(
                        _isFullScreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                      ),
                      label: _isFullScreen ? 'Exit Fullscreen' : 'Fullscreen',
                    ),
                  ],
                  onTap: (index) {
                    if (index == 0) {
                      _playPause();
                    } else if (index == 1) {
                      _stop();
                    } else if (index == 2) {
                      _toggleFullScreen();
                    }
                  },
                ),
        ));
  }
}
