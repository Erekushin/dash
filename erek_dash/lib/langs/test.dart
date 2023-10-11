// import 'dart:math';

// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// // don't forget "with SingleTickerProviderStateMixin"
// class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation _animation;
//   AnimationStatus _status = AnimationStatus.dismissed;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 400));
//     _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         _status = status;
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ,
//       ),
//     );
//   }
// }
