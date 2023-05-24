import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tv_app/pages/VideoPage.dart';

class TVList extends StatefulWidget {
  @override
  _TVListState createState() => _TVListState();
}

class _TVListState extends State<TVList> {
  List<dynamic> tvShows = [];

  @override
  void initState() {
    super.initState();
    fetchTVShows();
  }

  Future<void> fetchTVShows() async {
    try {
      final response =
          await http.get(Uri.parse('http://103.210.57.36:9191/api/tv_app_api'));
      if (response.statusCode == 200) {
        setState(() {
          tvShows = json.decode(response.body);
        });
      } else {
        print('Failed to fetch TV shows. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching TV shows: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Shows'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75, // Adjust the aspect ratio as needed
        ),
        itemCount: tvShows.length,
        itemBuilder: (BuildContext context, int index) {
          final tvShow = tvShows[index];

          return Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPage(tvShow['stream']),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio:
                            16 / 9, // Adjust the aspect ratio as needed
                        child: Image.network(
                          tvShow['logo'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          tvShow['tag'],
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          tvShow['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}
