import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/gates.dart';
import 'idea_cont.dart';

class InterestingIdeas extends StatefulWidget {
  const InterestingIdeas({super.key});

  @override
  State<InterestingIdeas> createState() => _InterestingIdeasState();
}

class _InterestingIdeasState extends State<InterestingIdeas> {
  final cont = Get.find<IdeaCont>();
  bool editvisible = false;
  String chosenId = '';
  @override
  void initState() {
    cont.allIdeas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: const Text('New Ideas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(children: [
          GetX<IdeaCont>(builder: (littleCont) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: littleCont.interestingIdeaList.length,
                itemBuilder: (c, i) {
                  return InkWell(
                    onLongPress: () {
                      chosenId = littleCont.entryNames[i];
                      cont.ideaTxt.text =
                          littleCont.interestingIdeaList[i]['idea'];
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
                      child: Text(littleCont.interestingIdeaList[i]['idea']),
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
                                controller: cont.ideaTxt,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                cont.updateIdea(chosenId);
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
                                cont.deleteIdea(chosenId);
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
                    productivityGate(context, 'what you got?', cont.ideaTxt,
                        () {
                      cont.insertIdea();
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
