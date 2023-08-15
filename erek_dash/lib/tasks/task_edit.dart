import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../boxes/boxcont.dart';
import 'task_cont.dart';
import '../helpers/time.dart';
import 'task_model.dart';
import '../widgets/buttons.dart';
import '../widgets/widget_tools.dart';

class TaskEdit extends StatefulWidget {
  TaskEdit(
      {super.key,
      required this.item,
      required this.selectedLabelid,
      required this.selectedLabelname});
  final Task item;
  String selectedLabelname;
  int selectedLabelid;
  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  final cont = Get.find<TaskCont>();
  final boxCont = Get.find<BoxCont>();

  TimeHelper timeHelper = TimeHelper();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Set this to true
        backgroundColor: Colors.black.withOpacity(.8),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 60,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(
                    left: 40, right: 40, top: 5, bottom: 5),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: cont.editCnt,
                  maxLines: null, // Set maxLines to null for multiline support
                  decoration: const InputDecoration(
                    hintText: 'new task... ',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 120,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(
                    left: 40, right: 40, top: 5, bottom: 5),
                padding: const EdgeInsets.all(10),
                child: const TextField(
                  maxLines: null, // Set maxLines to null for multiline support
                  decoration: InputDecoration(
                    hintText: 'description... ',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(
                    left: 40, right: 40, top: 5, bottom: 5),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        taskProperty(
                            'starting date',
                            TextField(
                              enabled: false,
                              onTap: () {},
                              textAlign: TextAlign.center,
                              controller: cont.editstartingDate,
                            ), () async {
                          String incomingValue =
                              await timeHelper.selectDate(context);
                          if (incomingValue.isNotEmpty) {
                            cont.editstartingDate.text = incomingValue;
                          }
                        }),
                        taskProperty(
                            'starting time',
                            TextField(
                              enabled: false,
                              onTap: () {},
                              textAlign: TextAlign.center,
                              controller: cont.editstartingTime,
                            ), () async {
                          String incomingValue =
                              await timeHelper.selectTime(context);
                          if (incomingValue.isNotEmpty) {
                            cont.editstartingTime.text = incomingValue;
                          }
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        taskProperty(
                            'pinned date',
                            TextField(
                              enabled: false,
                              onTap: () {},
                              textAlign: TextAlign.center,
                              controller: cont.editpinnedDate,
                            ), () async {
                          String incomingValue =
                              await timeHelper.selectDate(context);
                          if (incomingValue.isNotEmpty) {
                            cont.editpinnedDate.text = incomingValue;
                          }
                        }),
                        taskProperty(
                            'pinned time',
                            TextField(
                              enabled: false,
                              onTap: () {},
                              textAlign: TextAlign.center,
                              controller: cont.editpinnedTime,
                            ), () async {
                          String incomingValue =
                              await timeHelper.selectTime(context);
                          if (incomingValue.isNotEmpty) {
                            cont.editpinnedTime.text = incomingValue;
                          }
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        taskProperty(
                            'importancy',
                            TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              onTap: () {},
                              textAlign: TextAlign.center,
                              controller: cont.editimportancy,
                            ),
                            () {}),
                        taskProperty(
                            'label',
                            Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: InkWell(
                                      onTap: () {
                                        // builtInDropDown(context);
                                        Get.defaultDialog(
                                            title: '',
                                            content: SizedBox(
                                              width: 200,
                                              height: 200,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      boxCont.boxList.length,
                                                  itemBuilder: (c, i) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          widget.selectedLabelname =
                                                              boxCont.boxList[i]
                                                                  ['boxname'];
                                                        });
                                                        widget.selectedLabelid =
                                                            boxCont.boxList[i]
                                                                ['id'];
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              color:
                                                                  Colors.black),
                                                          child: Text(
                                                            boxCont.boxList[i]
                                                                ['boxname'],
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          )),
                                                    );
                                                  }),
                                            ));
                                      },
                                      child: Center(
                                          child:
                                              Text(widget.selectedLabelname))),
                                )),
                            () {})
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text('Duration  '),
                        Text(widget.item.spendingTime.toString()),
                        const Text('  hours')
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text('Remaining  '),
                        Text(widget.item.remaininghours.toString()),
                        const Text('  hours'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        standartBtn('save new values', () {
                          int speningHoursedit = 1;
                          String fullstartingTimeedit = '';
                          String fullpinnedTimeedit = '';
                          print('object1');
                          if (cont.editstartingDate.text.isNotEmpty &&
                              cont.editpinnedDate.text.isNotEmpty) {
                            speningHoursedit = timeHelper.calculateHoursDifference(
                                '${cont.editstartingDate.text} ${cont.editstartingTime.text}:00.000',
                                '${cont.editpinnedDate.text} ${cont.editpinnedTime.text}:00.000');

                            fullstartingTimeedit =
                                '${cont.editstartingDate.text} ${cont.editstartingTime.text}:00.000';
                            fullpinnedTimeedit =
                                '${cont.editpinnedDate.text} ${cont.editpinnedTime.text}:00.000';
                          }
                          cont.updateTask(widget.item.id!, {
                            'task': cont.editCnt.text,
                            'updated_time': GlobalValues.nowStr,
                            'starting_time': fullstartingTimeedit,
                            'pinned_time': fullpinnedTimeedit,
                            'importancy': cont.editimportancy.text,
                            'spending_time': speningHoursedit,
                            'label': widget.selectedLabelid,
                            'labelname': widget.selectedLabelname
                          });
                        }),
                        const SizedBox(width: 10),
                        standartBtn('Nailed It', () {
                          cont.updateTask(widget.item.id!, {
                            'done_it': 1,
                            'finished_time': GlobalValues.nowStrShort
                          });
                        }),
                        IconButton(
                            onPressed: () {
                              cont.deleteTask(widget.item.id!);
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                              size: 30,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
