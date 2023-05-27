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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff27A0C6),
        elevation: 0,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: DrawerNav(),
      ),
      body: Column(
        children: [
          Expanded(
            child: OrientationBuilder(
              builder: (context, orientation) {
                final isPortrait = orientation == Orientation.portrait;
                return Container(
                  height: isPortrait
                      ? MediaQuery.of(context).size.height * 0.8
                      : MediaQuery.of(context).size.height,
                  child:
                      // children: [
                      VlcPlayer(
                    controller: _controller,
                    aspectRatio: isPortrait
                        ? 16 / 9
                        : 3, // Adjust the aspect ratio as needed
                    placeholder:
                        const Center(child: CircularProgressIndicator()),
                  ),
                  // if (_isFullScreen && isPortrait) ...[
                  //   Positioned.fill(
                  //     child: GestureDetector(
                  //       onTap: _toggleFullScreen,
                  //       child: Container(
                  //         color: const Color.fromARGB(0, 201, 8, 8),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                  // ],
                );
              },
            ),
          ),
          // const SizedBox(height: 16.0),
          // if (!_isFullScreen) ...[
          //   Text(
          //     'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which dont look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isnt anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.',
          //     style: const TextStyle(fontSize: 18),
          //   ),
          // ] else
          //   ...[]

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     IconButton(
          //       icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          //       onPressed: _playPause,
          //     ),
          //     IconButton(
          //       icon: const Icon(Icons.stop),
          //       onPressed: _stop,
          //     ),
          //     Slider(
          //       value: _volume,
          //       min: 0.0,
          //       max: 100.0,
          //       onChanged: _setVolume,
          //     ),
          //     IconButton(
          //       icon: Icon(
          //         _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
          //       ),
          //       onPressed: _toggleFullScreen,
          //     ),
          //   ],
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          const BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.volume_up),
            label: 'Volume',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(
              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
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
            // Handle volume
          } else if (index == 3) {
            _toggleFullScreen();
          }
        },
      ),
    );
  }
}
