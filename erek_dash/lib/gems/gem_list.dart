import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/gates.dart';
import 'gem_cont.dart';

class Gems extends StatefulWidget {
  const Gems({super.key});

  @override
  State<Gems> createState() => _GemsState();
}

class _GemsState extends State<Gems> {
  final cont = Get.find<GemCont>();
  bool editvisible = false;
  int chosenId = 0;
  @override
  void initState() {
    cont.allGems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: const Text('Gems'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(children: [
          GetX<GemCont>(builder: (littleCont) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: littleCont.gemList.length,
                itemBuilder: (c, i) {
                  return InkWell(
                    onLongPress: () {
                      chosenId = littleCont.gemList[i]['id'];
                      cont.updateTxt.text = littleCont.gemList[i]['gem'];
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
                      child: Text(littleCont.gemList[i]['gem']),
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
                      margin:
                          const EdgeInsets.only(top: 10, bottom: 10, left: 10),
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
                                controller: cont.updateTxt,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                cont.updateGem(chosenId);
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
                                cont.deleteGem(chosenId);
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
                    productivityGate(context, 'what you learned ?', cont.gemTxt,
                        () {
                      cont.insertGem();
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
