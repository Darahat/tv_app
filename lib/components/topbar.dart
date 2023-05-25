import 'package:flutter/material.dart';

class TopBar extends PreferredSize {
  var title;
  // final VoidCallback? onMenuPressed;

  TopBar({super.key, required this.title})
      : super(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Add your search logic here
              },
            ),
            title: Text(title),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Add your search logic here
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Add your more options logic here
                },
              ),
            ],
          ),
        );
}

// class TopBar extends StatelessWidget {
//   const TopBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const double appBarHeight = 56.0; // Adjust the height as needed
//     return PreferredSize(
//         preferredSize: const Size.fromHeight(appBarHeight),
//         child: AppBar(
//             leading: IconButton(
//               icon: const Icon(Icons.menu),
//               onPressed: () {
//                 // Add your navigation menu logic here
//               },
//             ),
//             title: const Text('Your Title'),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.search),
//                 onPressed: () {
//                   // Add your search logic here
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.more_vert),
//                 onPressed: () {
//                   // Add your more options logic here
//                 },
//               ),
//             ]));
//   }
// }
