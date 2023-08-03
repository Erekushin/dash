import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'note_cont.dart';

class NoteEdit extends StatelessWidget {
  NoteEdit({super.key, required this.id});
  final int id;
  final cont = Get.find<NoteCont>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // cont.updateNewIdea(id);
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
                      flex: 8,
                      child: TextField(
                        controller: cont.notetxt,
                        maxLines:
                            null, // Set maxLines to null for multiline support
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black)),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              height: 40,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Colors.black,
                              ),
                              margin: const EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () {
                                  print('fdddffdfd');
                                },
                                child: Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'choose',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.all(5),
                                child: IconButton(
                                    onPressed: () {
                                      //delete
                                      //cont.deleteIdea(id);
                                      print('dfdf');
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 20,
                                    ))),
                          ),
                        ],
                      ),
                    )
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
