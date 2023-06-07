import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:medialink24tv/pages/tv_list.dart';

class DrawerNav extends StatefulWidget {
  DrawerNav({Key? key}) : super(key: key);

  _DrawerNavState createState() => _DrawerNavState();
}

class _DrawerNavState extends State<DrawerNav> {
  Route _createAnimatedRoute(page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

//  const Cubic(0.35, 0.91, 0.33, 0.97)
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.all(5),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0),
                        bottomRight: const Radius.circular(100.0),
                        bottomLeft: const Radius.circular(10.0))
                    // borderRadius: new BorderRadius.all(Radius.circular(10))
                    ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: new Image.asset(
                          'images/streaming-app-icon.png',
                          height: 60,
                          width: 60,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                'MediaLink24 TV',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: .8,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                            ]),
                      ),
                    ])),
            decoration: const BoxDecoration(
              color: Color(0xff27A0C6),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, size: 30, color: Colors.green),
            trailing: const Icon(Icons.keyboard_arrow_right),
            title: const Text('Home'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);

              Navigator.of(context).push(_createAnimatedRoute(new TVList()));
            },
          ),
        ],
      ),
    );
  }
}
