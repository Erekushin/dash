import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'note_cont.dart';

class NoteGate extends StatelessWidget {
  NoteGate({super.key, required this.incomingIsMoving});
  bool incomingIsMoving;
  final cont = Get.find<NoteCont>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        cont.insertNote(incomingIsMoving);
        Get.back();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Set this to true
        backgroundColor: Colors.black.withOpacity(.8),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            height: 600,
            child: Card(
              color: Colors.white,
              shadowColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: cont.noteTitle,
                        maxLines:
                            null, // Set maxLines to null for multiline support
                        decoration: const InputDecoration(
                            hintText: 'Title',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black)),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: cont.notetxt,
                        maxLines:
                            null, // Set maxLines to null for multiline support
                        decoration: const InputDecoration(
                            hintText: 'Write here ...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black)),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
