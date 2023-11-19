import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/buttons.dart';
import 'note_cont.dart';
import 'note_gate.dart';
import '../widgets/edit_tool.dart';
import '../widgets/gates.dart';

class NoteLabel extends StatefulWidget {
  const NoteLabel({super.key});

  @override
  State<NoteLabel> createState() => _NoteLabelState();
}

class _NoteLabelState extends State<NoteLabel> {
  final cont = Get.find<NoteCont>();
  bool editvisible = false;
  String chosenId = '';

  @override
  void initState() {
    cont.allLabels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: const Text('Topics'),
        actions: [
          Container(
            alignment: Alignment.center,
            width: 150,
            height: 20,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: TextField(
              controller: cont.searchTxt,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'search '),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(children: [
          GetX<NoteCont>(builder: (littleCont) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: littleCont.labelList.length,
                itemBuilder: (c, i) {
                  return InkWell(
                    onTap: () {
                      cont.chosenLabel.value = littleCont.labelList[i]['label'];
                      Get.to(() => const Notes());
                    },
                    onLongPress: () {
                      chosenId = littleCont.labelIds[i];
                      cont.labeltxt.text = littleCont.labelList[i]['label'];
                      setState(() {
                        editvisible = true;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(littleCont.labelList[i]['label']),
                    ),
                  );
                });
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                editTool(editvisible, cont.labeltxt, () {
                  cont.updatelabel(chosenId);
                  setState(() {
                    editvisible = false;
                  });
                }, () {
                  cont.deletelabel(chosenId);
                  setState(() {
                    editvisible = false;
                  });
                }),
                addWhiteBtn(Icons.add, () {
                  productivityGate(context, "labelname", cont.labeltxt, () {
                    cont.insertlabel();
                    Navigator.of(context).pop();
                  });
                }),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with TickerProviderStateMixin {
  final cont = Get.find<NoteCont>();
  bool editvisible = false;
  String chosenId = '';
  @override
  void initState() {
    cont.labelNotes();
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
                          chosenId = littleCont.entryNames[i];
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
                                                  flex: 2,
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
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    item['label'],
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
                alignment: Alignment.bottomRight,
                child: addWhiteBtn(Icons.add, () {
                  Get.to(() => NoteGate(
                        incomingIsMoving: false,
                      ));
                }),
              )
            ],
          );
        }),
      ),
    );
  }
}
