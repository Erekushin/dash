import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'task_cont.dart';
import '../helpers/time.dart';
import '../models/task_model.dart';
import '../widgets/buttons.dart';
import '../widgets/widget_tools.dart';

class TaskEdit extends StatelessWidget {
  TaskEdit({super.key, required this.item});
  final cont = Get.find<TaskCont>();
  final Task item;

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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text('Duration  '),
                        Text(item.spendingTime.toString()),
                        const Text('  hours')
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text('Remaining  '),
                        Text(item.remaininghours.toString()),
                        const Text('  hours'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        standartBtn('save new values', () {
                          int speningHours = timeHelper.calculateHoursDifference(
                              '${cont.editstartingDate.text} ${cont.editstartingTime.text}:00.000',
                              '${cont.editpinnedDate.text} ${cont.editpinnedTime.text}:00.000');
                          cont.updateTask(item.id!, {
                            'task': cont.editCnt.text,
                            'updated_time': GlobalValues.nowStr,
                            'starting_time':
                                '${cont.editstartingDate.text} ${cont.editstartingTime.text}:00.000',
                            'pinned_time':
                                '${cont.editpinnedDate.text} ${cont.editpinnedTime.text}:00.000',
                            'importancy': cont.editimportancy.text,
                            'spending_time': speningHours,
                          });
                        }),
                        const SizedBox(width: 10),
                        standartBtn('Nailed It', () {
                          cont.updateTask(item.id!, {
                            'done_it': 1,
                            'finished_time': GlobalValues.nowStr
                          });
                        }),
                        IconButton(
                            onPressed: () {
                              cont.deleteTask(item.id!);
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
