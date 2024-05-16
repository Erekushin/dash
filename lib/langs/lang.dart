import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/buttons.dart';
import 'lang_cont.dart';
import 'lang_test.dart';

class Lang extends StatefulWidget {
  Lang({super.key, required this.langname, required this.langId});
  String langname;
  String langId;
  @override
  State<Lang> createState() => _LangState();
}

class _LangState extends State<Lang> {
  final cont = Get.find<LangCont>();
  bool editvisible = false;
  String chosenId = '';
  @override
  void initState() {
    if (cont.chosenLang != widget.langname) {
      cont.wordList.clear();
      cont.chosenLang = widget.langname;
      cont.chosenLangId = widget.langId;
      cont.alllangwords();
    } else {
      if (cont.searchLevel != 0) {
        cont.wordList.clear();
        cont.searchLevel = 0;
        cont.chosenLang = widget.langname;
        cont.chosenLangId = widget.langId;
        cont.alllangwords();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: Text(widget.langname),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => LangTest(
                      words: cont.wordList,
                    ));
                // Get.to(() => const HomePage());
              },
              icon: const Icon(Icons.amp_stories_sharp))
        ],
      ),
      body: GetX<LangCont>(builder: (littleCont) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 120),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: littleCont.wordList.length,
                    itemBuilder: (c, i) {
                      return InkWell(
                        onTap: () {
                          chosenId = littleCont.wordentryNames[i];
                          cont.wordtxt.text = littleCont.wordList[i]['word'];
                          cont.translationtxt.text =
                              littleCont.wordList[i]['translation'];
                          cont.level = littleCont.wordList[i]['level'];
                          wordgate(context, littleCont.wordList[i]['word'],
                              littleCont.wordList[i]['translation'], () {
                            Navigator.of(context).pop();
                          }, () {
                            cont.level--;
                            cont.updateword(chosenId);
                            Navigator.of(context).pop();
                          }, () {
                            cont.level++;
                            cont.updateword(chosenId);
                            Navigator.of(context).pop();
                          });
                        },
                        onLongPress: () {
                          chosenId = littleCont.wordentryNames[i];
                          cont.wordtxt.text = littleCont.wordList[i]['word'];
                          cont.translationtxt.text =
                              littleCont.wordList[i]['translation'];
                          cont.level = littleCont.wordList[i]['level'];
                          setState(() {
                            editvisible = true;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                littleCont.wordList[i]['word'],
                                textAlign: TextAlign.end,
                              )),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                width: 20,
                                height: 2,
                                color: Colors.black,
                              ),
                              Expanded(
                                  child: Text(
                                      littleCont.wordList[i]['translation']))
                            ],
                          ),
                        ),
                      );
                    })),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                        visible: editvisible,
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              border: Border.all(color: Colors.black)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Column(children: [
                                    TextField(
                                      controller: cont.wordtxt,
                                    ),
                                    TextField(
                                      controller: cont.translationtxt,
                                    )
                                  ]),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    cont.updateword(chosenId);
                                    setState(() {
                                      editvisible = false;
                                    });
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
                                    cont.deleteword(chosenId);
                                    setState(() {
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
                    InkWell(
                      onTap: () {
                        cont.clearFields();
                        setState(() {
                          editvisible = false;
                        });
                        newwordgate(context, cont.wordtxt, cont.translationtxt,
                            () {
                          cont.insertword();
                          Navigator.of(context).pop();
                        });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    wordLevelBtn('failed', () {
                      cont.searchLevel = -1;
                    }),
                    wordLevelBtn('daily', () {
                      cont.searchLevel = 0;
                    }),
                    wordLevelBtn('week', () {
                      cont.searchLevel = 1;
                    }),
                    wordLevelBtn('month', () {
                      cont.searchLevel = 2;
                    }),
                    wordLevelBtn('archive', () {
                      cont.searchLevel = 3;
                    }),
                  ],
                ),
              ],
            )
          ]),
        );
      }),
    );
  }

  String focusedLevel = 'daily';
  Widget wordLevelBtn(String title, Function func) {
    return InkWell(
      onTap: () {
        func();
        cont.alllangwords();
        setState(() {
          focusedLevel = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: Colors.black)),
        child: Column(children: [
          Text(title),
          Visibility(
              visible: focusedLevel == title,
              child: Text(cont.wordList.length.toString()))
        ]),
      ),
    );
  }
}

Object newwordgate(BuildContext conte, TextEditingController txtCont,
    TextEditingController translationtxt, Function func) {
  return showGeneralDialog(
    context: conte,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(conte).modalBarrierDismissLabel,
    barrierColor: const Color.fromARGB(133, 0, 0, 0),
    pageBuilder: (conte, anim1, anim2) {
      return StatefulBuilder(
        builder: (conte, setstate) {
          return SafeArea(
            child: GestureDetector(
              onTap: () {
                func();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true, // Set this to true
                backgroundColor: Colors.black.withOpacity(.8),
                body: Center(
                  child: SizedBox(
                    width: 300,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 100,
                          child: Card(
                            color: Colors.white,
                            shadowColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: txtCont,
                                maxLines:
                                    null, // Set maxLines to null for multiline support
                                decoration: const InputDecoration(
                                    hintText: 'word', border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: Card(
                            color: Colors.white,
                            shadowColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: translationtxt,
                                maxLines:
                                    null, // Set maxLines to null for multiline support
                                decoration: const InputDecoration(
                                    hintText: 'translation',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Object wordgate(BuildContext conte, String word, String translation,
    Function func, Function leveldown, Function levelup) {
  return showGeneralDialog(
    context: conte,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(conte).modalBarrierDismissLabel,
    barrierColor: const Color.fromARGB(133, 0, 0, 0),
    pageBuilder: (conte, anim1, anim2) {
      return StatefulBuilder(
        builder: (conte, setstate) {
          return SafeArea(
            child: GestureDetector(
              onTap: () {
                func();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true, // Set this to true
                backgroundColor: Colors.black.withOpacity(.8),
                body: Center(
                  child: SizedBox(
                    width: 300,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 100,
                          child: Card(
                            color: Colors.white,
                            shadowColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(word),
                                  const Divider(),
                                  Text(translation)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: Card(
                            color: Colors.white,
                            shadowColor: Colors.transparent,
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    standartBtn("level down", () {
                                      leveldown();
                                    }),
                                    standartBtn("level up", () {
                                      levelup();
                                    }),
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
