import 'package:erek_dash/sequences/sequence_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/time.dart';
import '../widgets/widget_tools.dart';

class RunningSequence extends StatefulWidget {
  const RunningSequence({super.key});

  @override
  State<RunningSequence> createState() => _PackagedHabitsState();
}

class _PackagedHabitsState extends State<RunningSequence> {
  final cont = Get.find<SequenceCont>();
  TimeHelper timeHelper = TimeHelper();

  @override
  Widget build(BuildContext context) {
    return GetX<SequenceCont>(
      builder: (littleCont) {
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: littleCont.seqitems.length,
            itemBuilder: (c, i) {
              if (littleCont.seqitems[i]['ismoveable']) {
                return littleCont.isDone.isEmpty || !littleCont.isDone[i]
                    ? InkWell(
                        onTap: () {
                          habitGate(context, littleCont.seqitems[i]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(10),
                          child: Text(littleCont.seqitems[i]['habit']),
                        ))
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            border: Border.all(color: Colors.green, width: 3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      );
              } else {
                return const SizedBox();
              }
            });
      },
    );
  }

  Object habitGate(BuildContext conte, var item) {
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
                  if (cont.stardedtimeofHabit.text.isNotEmpty &&
                      cont.finfishedtimeofHabit.text.isNotEmpty &&
                      cont.successPointofHabit.text.isNotEmpty) {
                    cont.createHabitProgress(item['habit'], item['id']);
                  }
                  Navigator.of(context).pop();
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: true, // Set this to true
                  backgroundColor: Colors.black.withOpacity(.8),
                  body: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 5, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              taskProperty(
                                  'starting time',
                                  TextField(
                                    enabled: false,
                                    textAlign: TextAlign.center,
                                    controller: cont.stardedtimeofHabit,
                                  ), () async {
                                cont.stardedtimeofHabit.text =
                                    await timeHelper.selectTime(context);
                              }),
                              taskProperty(
                                  'finished time',
                                  TextField(
                                    textAlign: TextAlign.center,
                                    enabled: false,
                                    controller: cont.finfishedtimeofHabit,
                                  ), () async {
                                cont.finfishedtimeofHabit.text =
                                    await timeHelper.selectTime(context);
                              }),
                              taskProperty(
                                  'success point',
                                  TextField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: cont.successPointofHabit,
                                  ),
                                  () {})
                            ],
                          ),
                        ),
                      ],
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
}
