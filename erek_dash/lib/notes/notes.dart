import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'note_cont.dart';
import 'note_gate.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with TickerProviderStateMixin {
  final cont = Get.find<NoteCont>();
  bool editvisible = false;
  int chosenId = 0;
  @override
  void initState() {
    cont.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GetX<NoteCont>(builder: (littleCont) {
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
                    itemCount: littleCont.notes.length,
                    shrinkWrap: true,
                    itemBuilder: (c, i) {
                      var item = littleCont.notes[i];
                      return InkWell(
                        onLongPress: () {
                          chosenId = item['id'];
                          setState(() {
                            editvisible = true;
                          });
                        },
                        onTap: () {
                          setState(() {
                            littleCont.expandedbool[i] =
                                !littleCont.expandedbool[i];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: child,
                              );
                            },
                            child: littleCont.expandedbool[i]
                                ? Container(
                                    key: const ValueKey(1),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['note'],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      item['created_time']
                                                          .toString()
                                                          .substring(0, 10)),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    item['title'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    key: const ValueKey(2),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(item['created_time']
                                                .toString()
                                                .substring(0, 10)),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              item['title'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ]),
                                  ),
                          ),
                        ),
                      );
                    }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: Visibility(
                          visible: editvisible,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                border: Border.all(color: Colors.black)),
                            child: Row(children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    littleCont.deleteNote(chosenId);
                                    editvisible = false;
                                  });
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              )
                            ]),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => NoteGate(
                              incomingIsMoving: false,
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: Colors.black)),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
