import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tv_app/pages/videoPage.dart';
import 'package:tv_app/components/sidenavbar.dart';
import 'package:tv_app/components/tv_listComponent.dart';

class TVList extends StatefulWidget {
  const TVList({super.key});

  @override
  _TVListState createState() => _TVListState();
}

class _TVListState extends State<TVList> {
  late TabController _tabController;

  List<dynamic> tvShows = [];
  List<dynamic> sportsChannel = [];
  List<dynamic> musicChannel = [];
  List<dynamic> englishChannel = [];
  List<dynamic> hindiChannel = [];
  List<dynamic> banglaChannel = [];

  @override
  void initState() {
    super.initState();
    fetchTVShows();
  }

  int _screen = 0;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchTVShows() async {
    try {
      final response =
          await http.get(Uri.parse('http://103.210.57.36:9191/api/tv_app_api'));
      if (response.statusCode == 200) {
        setState(() {
          tvShows = json.decode(response.body);
          sportsChannel =
              tvShows.where((tvShow) => tvShow['tag'] == 'sports').toList();
          musicChannel =
              tvShows.where((tvShow) => tvShow['tag'] == 'music').toList();
          englishChannel =
              tvShows.where((tvShow) => tvShow['tag'] == 'english').toList();
          hindiChannel =
              tvShows.where((tvShow) => tvShow['tag'] == 'hindi').toList();
          banglaChannel =
              tvShows.where((tvShow) => tvShow['tag'] == 'bangla').toList();
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
    return MaterialApp(
        home: DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xff27A0C6),
                elevation: 0,
                title: const Text('MediaLink24 TV'),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Sports'),
                    Tab(text: 'Music'),
                    Tab(text: 'Bangla'),
                    Tab(text: 'Hindi'),
                    Tab(text: 'English'),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: MySearchDelegate(tvShows));
                    },
                  ),
                ],
              ),
              drawer: Drawer(
                child: DrawerNav(),
              ),
              body: TabBarView(
                children: [
                  Tv_listComponent(
                    tvshow: sportsChannel,
                    key: null,
                  ),
                  Tv_listComponent(
                    tvshow: musicChannel,
                    key: null,
                  ),
                  Tv_listComponent(
                    tvshow: banglaChannel,
                    key: null,
                  ),
                  Tv_listComponent(
                    tvshow: hindiChannel,
                    key: null,
                  ),
                  Tv_listComponent(
                    tvshow: englishChannel,
                    key: null,
                  ),
                ],
              ),
            )));
  }
}

class MySearchDelegate extends SearchDelegate {
  final List<dynamic> tvShows;
  MySearchDelegate(this.tvShows);

  @override
  Widget? buildLeading(BuildContext context) => Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 6, 150, 198), // Set the background color
        borderRadius: BorderRadius.circular(10), // Set the border radius
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0)
                .withOpacity(0.5), // Set the shadow color
            spreadRadius: 2, // Set the spread radius
            blurRadius: 5, // Set the blur radius
            offset: const Offset(0, 3), // Set the shadow offset
          ),
        ],
      ),
      child: IconButton(
          onPressed: () => close(context, null),
          icon: const Icon(Icons.arrow_back)));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () => {
                  if (query.isEmpty)
                    {
                      close(context, null),
                    }
                  else
                    {
                      query = '',
                    }
                },
            icon: const Icon(Icons.close))
      ];

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> searchResults = tvShows.where((tvShow) {
      final result = tvShow['title'].toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        final tvShow = searchResults[index];
        return ListTile(
            title: Text(tvShow['title']),
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
            });
      },
    );
  }
}
