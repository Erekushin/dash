import 'package:flutter/material.dart';

Widget standartBtn(String title, Function func) {
  return InkWell(
    onTap: () {
      func();
    },
    child: Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
