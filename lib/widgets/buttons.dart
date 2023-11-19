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

Widget addWhiteBtn(IconData icn, Function func) {
  return InkWell(
    onTap: () {
      func();
    },
    child: Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black)),
      child: Icon(
        icn,
        color: Colors.black,
        size: 30,
      ),
    ),
  );
}

Widget erekBtn(String title, bool clrBool, Function func) {
  return Padding(
    padding: const EdgeInsets.only(left: 0, right: 0),
    child: Expanded(
      flex: 1,
      child: InkWell(
        onTap: () => func(),
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          margin: const EdgeInsets.all(3),
          alignment: Alignment.center,
          height: 50,
          decoration: BoxDecoration(
              gradient: clrBool
                  ? const LinearGradient(colors: [
                      Color.fromARGB(255, 57, 19, 161),
                      Colors.black,
                    ])
                  : const LinearGradient(colors: [
                      Colors.black,
                      Colors.black,
                    ]),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
