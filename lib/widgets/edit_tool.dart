import 'package:flutter/material.dart';

Widget editTool(
    bool vis, TextEditingController txtCont, Function update, Function delete) {
  return Visibility(
      visible: vis,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 0),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: Colors.black)),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            width: 200,
            child: TextField(
              controller: txtCont,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              update();
            },
            child: const Icon(
              Icons.update,
              color: Colors.blueAccent,
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              delete();
            },
            child: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 30,
            ),
          )
        ]),
      ));
}
