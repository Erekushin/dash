import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/time.dart';
import '../widgets/widget_tools.dart';
import 'task_cont.dart';

// ignore: must_be_immutable
class TaskGate extends StatefulWidget {
  TaskGate({super.key, required this.incomingIsMoving});
  bool incomingIsMoving;
  @override
  State<TaskGate> createState() => _TaskGateState();
}

class _TaskGateState extends State<TaskGate> {
  final cont = Get.find<TaskCont>();

  TimeHelper timeHelper = TimeHelper();
  File? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('data: ${cont.parentTask}');
        cont.createTask(widget.incomingIsMoving);
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
              height: 120,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              margin:
                  const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: cont.txtCnt,
                maxLines: null, // Set maxLines to null for multiline support
                decoration: const InputDecoration(
                  hintText: 'new task... ',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
              height: 150,
              child: InkWell(
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    _image = File(pickedFile.path);
                    final imageBytes = await pickedFile.readAsBytes();
                    cont.boxImg.insert(0, imageBytes);
                  }
                  setState(() {});
                },
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shadowColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Stack(children: [
                              Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/imagedefault.png'))),
                              ),
                              const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              )
                            ]),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              margin:
                  const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
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
                            textAlign: TextAlign.center,
                            controller: cont.startingDate,
                          ), () async {
                        String incomingValue =
                            await timeHelper.selectDate(context);
                        if (incomingValue.isNotEmpty) {
                          cont.startingDate.text = incomingValue;
                        }
                      }),
                      taskProperty(
                          'starting time',
                          TextField(
                            enabled: false,
                            textAlign: TextAlign.center,
                            controller: cont.startingTime,
                          ), () async {
                        String incomingValue =
                            await timeHelper.selectTime(context);
                        if (incomingValue.isNotEmpty) {
                          cont.startingTime.text = incomingValue;
                        }
                      })
                    ],
                  ),
                  Row(
                    children: [
                      taskProperty(
                          'pinned time',
                          TextField(
                            enabled: false,
                            textAlign: TextAlign.center,
                            controller: cont.pinnedDate,
                          ), () async {
                        String incomingValue =
                            await timeHelper.selectDate(context);
                        if (incomingValue.isNotEmpty) {
                          cont.pinnedDate.text = incomingValue;
                        }
                      }),
                      taskProperty(
                          'pinned time',
                          TextField(
                            enabled: false,
                            textAlign: TextAlign.center,
                            controller: cont.pinnedTime,
                          ), () async {
                        String incomingValue =
                            await timeHelper.selectTime(context);
                        if (incomingValue.isNotEmpty) {
                          cont.pinnedTime.text = incomingValue;
                        }
                      }),
                    ],
                  ),
                  Row(
                    children: [
                      taskProperty(
                          'importancy',
                          TextField(
                            textAlign: TextAlign.center,
                            controller: cont.importancy,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
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
                                                itemCount: cont.boxList.length,
                                                itemBuilder: (c, i) {
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        cont.boxId =
                                                            cont.parentId =
                                                                cont.boxList[i]
                                                                    ['id'];
                                                        cont.boxName = cont
                                                            .boxList[i]['task'];
                                                        cont.parentTask =
                                                            cont.boxList[i];
                                                      });
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        margin: const EdgeInsets
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
                                                          cont.boxList[i]
                                                              ['task'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                  );
                                                }),
                                          ));
                                    },
                                    child: Center(child: Text(cont.boxName))),
                              )),
                          () {})
                    ],
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}

// ignore: must_be_immutable
class TaskGateNow extends StatefulWidget {
  const TaskGateNow({super.key});
  @override
  State<TaskGateNow> createState() => _TaskGateNowState();
}

class _TaskGateNowState extends State<TaskGateNow> {
  final cont = Get.find<TaskCont>();

  TimeHelper timeHelper = TimeHelper();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await cont.createTask(false);
        cont.parentTask['boxId'] = "now";
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
              height: 80,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              margin:
                  const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: cont.txtCnt,
                maxLines: null, // Set maxLines to null for multiline support
                decoration: const InputDecoration(
                  hintText: 'new task... ',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
