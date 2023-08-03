import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import 'configuration/configuration.dart';
import 'configuration/conf_cont.dart';
import 'habits/habit_cont.dart';
import 'idea_stream/idea_stream_cont.dart';
import 'notes/note_cont.dart';
import 'globals.dart';
import 'helpers/time.dart';
import 'habits/habit_list.dart';
import 'habits/packaged_habits.dart';
import 'idea_stream/incoming_ideas.dart';
import 'notes/notes.dart';
import 'tasks/completed_tasks.dart';
import 'tasks/task_edit.dart';
import 'tasks/tasklist.dart';
import 'widgets/widget_tools.dart';

class DashLanding extends StatefulWidget {
  const DashLanding({super.key});

  @override
  State<DashLanding> createState() => _DashLandingState();
}

class _DashLandingState extends State<DashLanding> {
  // final dbHelper = DatabaseHelper();

  // void update() async {
  //   final updatedData = {'id': 1, 'name': 'Updated John', 'age': 28};
  //   await dbHelper.updateData('my_table', updatedData);
  // }

  // void reaAfterUpdate() async {
  //   final updatedDataList = await dbHelper.fetchData('my_table');
  //   updatedDataList.forEach((data) {
  //     print('ID: ${data['id']}, Name: ${data['name']}, Age: ${data['age']}');
  //   });
  // }

  // void delete() async {
  //   await dbHelper.deleteData('my_table', 1);
  // }

  // void readAfterdeleter() async {
  //   final newDataList = await dbHelper.fetchData('my_table');
  //   newDataList.forEach((data) {
  //     print('ID: ${data['id']}, Name: ${data['name']}, Age: ${data['age']}');
  //   });
  // }

  Future<String> getExternalDirectoryPath() async {
    if (await Permission.storage.request().isGranted) {
      const directory = "storage/emulated/0/Documents/erekdash_data";
      return directory;
    } else {
      throw Exception('Permission denied');
    }
  }

  Future<void> writeToFile(String data) async {
    final directoryPath = await getExternalDirectoryPath();
    final customDirectoryPath = '$directoryPath/';

    // Create the custom directory if it doesn't exist
    Directory customDirectory = Directory(customDirectoryPath);
    if (!customDirectory.existsSync()) {
      customDirectory.createSync(recursive: true);
    }

    // Write data to the file
    final file = File('$customDirectoryPath/ideaGate.json');
    await file.writeAsString(data);
  }

  final contIdeaStream = Get.find<IdeaStreamCont>();
  final contTasks = Get.find<TaskCont>();
  final conthabit = Get.find<HabitCont>();
  GlobalKey<ScaffoldState> menuSidebarKey = GlobalKey<ScaffoldState>();
  TimeHelper timeHelper = TimeHelper();

  @override
  void initState() {
    super.initState();
    contIdeaStream.getAllNewIdeas();
    conthabit.getAllHabits();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GetX<ConfigurationCont>(builder: (confCont) {
        return Scaffold(
            backgroundColor: MyColors.mainColor,
            appBar: AppBar(
              title: confCont.habitTypeId.value != 0
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        GlobalStatics.habitType.firstWhere((element) =>
                            element['id'] ==
                            confCont.habitTypeId.value)['name'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Text('Erek dashboard'),
              actions: [
                IconButton(
                    onPressed: () {
                      menuSidebarKey.currentState?.openEndDrawer();
                    },
                    icon: const Icon(Icons.menu, color: Colors.white))
              ],
            ),
            key: menuSidebarKey,
            endDrawer: Container(
                width: 200,
                height: double.infinity,
                color: Colors.white,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.to(() => const Notes());
                            },
                            child: const Text(
                              'notes',
                              style: TextStyle(),
                            )),
                        TextButton(
                            onPressed: () {
                              Get.to(() => const Habits());
                            },
                            child: const Text(
                              'habits',
                              style: TextStyle(),
                            )),
                        TextButton(
                            onPressed: () {
                              Get.to(() => const Configuration());
                            },
                            child: const Text(
                              'configurations',
                              style: TextStyle(),
                            )),
                        TextButton(
                            onPressed: () {
                              Get.to(() => const CompletedTasks());
                            },
                            child: const Text(
                              'what have i done',
                              style: TextStyle(),
                            )),
                      ],
                    ),
                  ),
                )),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: Sizes.gWidth,
                    height: Sizes.gHeight - 150,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (c, i) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  margin: const EdgeInsets.all(10),
                                );
                              }),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: double.infinity,
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: InkWell(
                            onTap: () {
                              taskGate(context);
                            },
                            child: Center(child: GetX<TaskCont>(
                              builder: (littleCont) {
                                return Text(
                                  'there is ${littleCont.taskListBody.value.taskList.length} tasks in total / add here...',
                                  style: const TextStyle(color: Colors.white),
                                );
                              },
                            )),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: confCont.habitTypeId.value != 0
                                ? const PackagedHabits()
                                : const TaskList()),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: InkWell(
                                  onTap: () {
                                    ideaGate(context);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    margin: const EdgeInsets.all(10),
                                    child: Center(
                                      child: GetX<IdeaStreamCont>(
                                        builder: (littleCont) {
                                          return Text(
                                            '${littleCont.ideaList.length} incomings / Write here... ',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    margin: const EdgeInsets.all(10),
                                    child: const Center(
                                      child: Text(
                                        '5',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const IncomingIdeas()
              ],
            ));
      }),
    );
  }

  Object ideaGate(BuildContext conte) {
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
                  contIdeaStream.insertIdea();
                  Navigator.of(context).pop();
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
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              height: 300,
                              child: Card(
                                color: Colors.white.withOpacity(0),
                                shadowColor: Colors.transparent,
                                child: TextField(
                                  controller: contIdeaStream.ideaTxtCnt,
                                  maxLines:
                                      null, // Set maxLines to null for multiline support
                                  decoration: const InputDecoration(
                                      hintText: 'what do you have here. . . . ',
                                      border: InputBorder.none,
                                      hintStyle:
                                          TextStyle(color: Colors.white)),
                                  style: const TextStyle(color: Colors.white),
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

  Object taskGate(BuildContext conte) {
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
                  contTasks.insertTask();
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
                          height: 60,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 5, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: contTasks.txtCnt,
                            maxLines:
                                null, // Set maxLines to null for multiline support
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 5, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          child: const TextField(
                            maxLines:
                                null, // Set maxLines to null for multiline support
                            decoration: InputDecoration(
                              hintText: 'description... ',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
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
                                        textAlign: TextAlign.center,
                                        controller: contTasks.startingDate,
                                      ), () async {
                                    String incomingValue =
                                        await timeHelper.selectDate(context);
                                    if (incomingValue.isNotEmpty) {
                                      contTasks.startingDate.text =
                                          incomingValue;
                                    }
                                  }),
                                  taskProperty(
                                      'starting time',
                                      TextField(
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        controller: contTasks.startingTime,
                                      ), () async {
                                    String incomingValue =
                                        await timeHelper.selectTime(context);
                                    if (incomingValue.isNotEmpty) {
                                      contTasks.startingTime.text =
                                          incomingValue;
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
                                        controller: contTasks.pinnedDate,
                                      ), () async {
                                    String incomingValue =
                                        await timeHelper.selectDate(context);
                                    if (incomingValue.isNotEmpty) {
                                      contTasks.pinnedDate.text = incomingValue;
                                    }
                                  }),
                                  taskProperty(
                                      'pinned time',
                                      TextField(
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        controller: contTasks.pinnedTime,
                                      ), () async {
                                    String incomingValue =
                                        await timeHelper.selectTime(context);
                                    if (incomingValue.isNotEmpty) {
                                      contTasks.pinnedTime.text = incomingValue;
                                    }
                                  }),
                                ],
                              ),
                              taskProperty(
                                  'importancy',
                                  TextField(
                                    textAlign: TextAlign.center,
                                    controller: contTasks.importancy,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
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
