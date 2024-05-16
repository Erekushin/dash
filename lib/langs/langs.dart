import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/gates.dart';
import 'lang.dart';
import 'lang_cont.dart';

class Langs extends StatefulWidget {
  const Langs({super.key});

  @override
  State<Langs> createState() => _LangsState();
}

class _LangsState extends State<Langs> {
  final cont = Get.find<LangCont>();
  bool editvisible = false;
  String chosenId = '';

  @override
  void initState() {
    cont.allLangs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: const Text('langs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(children: [
          GetX<LangCont>(builder: (littleCont) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: littleCont.langList.length,
                itemBuilder: (c, i) {
                  return InkWell(
                    onTap: () {
                      Get.to(() => Lang(
                            langname: littleCont.langList[i]['lang'],
                            langId: littleCont.entryNames[i],
                          ));
                    },
                    onLongPress: () {
                      chosenId = littleCont.entryNames[i];
                      cont.langtxt.text = littleCont.langList[i]['lang'];
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
                      child: Text(littleCont.langList[i]['lang']),
                    ),
                  );
                });
          }),
        
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                    visible: editvisible,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 0),
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
                              child: TextField(
                                controller: cont.langtxt,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                cont.updatelang(chosenId);
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
                                cont.deletelang(chosenId);
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
                    productivityGate(context, 'what you got?', cont.langtxt,
                        () {
                      cont.insertlang();
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
          )
        ]),
      ),
    );
  }
}
