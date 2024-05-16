import 'package:flutter/material.dart';

Widget taskProperty(String title, Widget childWidget, Function func) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      Text(title),
      InkWell(
        onTap: () {
          func();
        },
        child: Container(
          height: 60,
          width: 130,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.black)),
          child: childWidget,
        ),
      )
    ],
  );
}

