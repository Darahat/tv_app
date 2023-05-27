import 'package:flutter/material.dart';
import 'package:tv_app/pages/videoPage.dart';

class Tv_listComponent extends StatefulWidget {
  final tvshow;

  const Tv_listComponent({required Key? key, required this.tvshow});
//  const VideoPage(
//       {required Key? key, required this.title, required this.streamingLink})
//       : super(key: key);
  @override
  State<Tv_listComponent> createState() => _Tv_listComponentState();
}

class _Tv_listComponentState extends State<Tv_listComponent> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.75, // Adjust the aspect ratio as needed
      ),
      itemCount: widget.tvshow.length,
      itemBuilder: (BuildContext context, int index) {
        final tvShow = widget.tvshow[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPage(
                      key: const Key(''),
                      streamingLink: tvShow['stream'],
                      title: tvShow['title'],
                    ),
                  ),
                );
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                      child: Image.network(
                        tvShow['logo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 0),
                      child: Text(
                        tvShow['title'],
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
