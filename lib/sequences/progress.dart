import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sequence_cont.dart';
import 'sequences_view.dart';

class Progression extends StatefulWidget {
  const Progression({super.key, required this.item, required this.id});
  final dynamic item;
  final String id;

  @override
  State<Progression> createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  final cont = Get.find<SequenceCont>();
  late String chosenId;

  RxBool editVis = false.obs;
  @override
  void initState() {
    cont.getAllProgress(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        cont.habitTxtCnt.clear();
        cont.stardedtimeofHabit.clear();
        cont.finfishedtimeofHabit.clear();
        cont.successPointofHabit.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.item['habit']),
          actions: [
            IconButton(
                onPressed: () {
                  addHabit(context, false, widget.id);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  cont.deleteHabit(widget.id);
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        backgroundColor: Colors.purpleAccent,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  infoText('date'),
                  infoText('started'),
                  infoText('finished'),
                  infoText('success'),
                ],
              ),
            ),
            GetX<SequenceCont>(builder: (littleCont) {
              return Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: littleCont.progressList.length,
                    itemBuilder: (c, i) {
                      var item = littleCont.progressList[i];
                      return InkWell(
                        onLongPress: () {
                          editVis.value = true;
                          chosenId = littleCont.progressEntries[i];
                          cont.stardedtimeofHabit.text =
                              item['starting_time'].toString();
                          cont.finfishedtimeofHabit.text =
                              item['finished_time'].toString();
                          cont.successPointofHabit.text =
                              item['success_count'].toString();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              infoText(
                                  item['day_date'].toString().substring(5, 10)),
                              infoText(item['starting_time'].toString()),
                              infoText(item['finished_time'].toString()),
                              infoText(item['success_count'].toString()),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }),
            const Spacer(),
            Obx(() => Visibility(
                  visible: editVis.value,
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              cont.deleteTaskProgress(chosenId, widget.id);
                              editVis.value = false;
                            },
                            icon: const Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              cont.updateTaskProgress(
                                  chosenId, widget.id, widget.item['habit']);
                              editVis.value = false;
                            },
                            icon: const Icon(Icons.save)),
                        editInput('started', cont.stardedtimeofHabit),
                        editInput('finished', cont.finfishedtimeofHabit),
                        editInput('success', cont.successPointofHabit)
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget editInput(String hintTxt, TextEditingController cnt) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        alignment: Alignment.center,
        child: TextField(
          controller: cnt,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintTxt,
          ),
        ),
      ),
    );
  }

  Widget infoText(String intText) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      alignment: Alignment.center,
      width: 70,
      child: Text(
        intText,
        style: const TextStyle(
            color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
