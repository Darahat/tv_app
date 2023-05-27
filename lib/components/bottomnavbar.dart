// import 'package:flutter/material.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);

//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _currentIndex = 0;
//   List<String> tabNames = const <String>[
//     'foo',
//     'bar',
//     'baz',
//     'quox',
//     'quuz',
//     'corge',
//     'grault',
//     'garply',
//     'waldo'
//   ];
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });

//     // Handle navigation or any other logic based on the selected index
//     // You can use a switch statement or if-else conditions to perform specific actions
//     switch (_currentIndex) {
//       case 0:
//         // Action for the first option
//         break;
//       case 1:
//         // Action for the second option
//         break;
//       case 2:
//         // Action for the third option
//         break;
//       case 3:
//         break;
//     }
//   }

//   int _screen = 0;

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: tabNames.length,
//       child: const Scaffold(
//         body: const TabBarView(
//           children: List<Widget>.generate(tabNames.length, (int index) {
//             switch (_screen) {
//               case 0:
//                 return const Center(
//                   child: const Text('First screen, ${tabNames[index]}'),
//                 );
//               case 1:
//                 return const Center(
//                   child: const Text('Second screen'),
//                 );
//             }
//           }),
//         ),
//         bottomNavigationBar: const Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const AnimatedCrossFade(
//               firstChild: const Material(
//                 color: Theme.of(context).primaryColor,
//                 child: const TabBar(
//                   isScrollable: true,
//                   tabs: const List.generate(tabNames.length, (index) {
//                     return const Tab(text: tabNames[index].toUpperCase());
//                   }),
//                 ),
//               ),
//               secondChild: const Container(),
//               crossFadeState: _screen == 0
//                   ? CrossFadeState.showFirst
//                   : CrossFadeState.showSecond,
//               duration: const Duration(milliseconds: 300),
//             ),
//             BottomNavigationBar(
//               currentIndex: _screen,
//               onTap: (int index) {
//                 setState(() {
//                   _screen = index;
//                 });
//               },
//               items: [
//                 const BottomNavigationBarItem(
//                   icon: const Icon(Icons.airplanemode_active),
//                   label: const Text('Airplane'),
//                 ),
//                 const BottomNavigationBarItem(
//                   icon: const Icon(Icons.motorcycle),
//                   label: const Text('Motorcycle'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
