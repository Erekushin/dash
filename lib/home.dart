import 'package:erek_dash/dayproductivity/productivity_cont.dart';
import 'package:erek_dash/sequences/running_sequence.dart';
import 'package:erek_dash/sequences/sequence_cont.dart';
import 'package:erek_dash/tasks/task_cont.dart';
import 'package:erek_dash/tasks/thetask.dart';
import 'package:erek_dash/value/value_history.dart';
import 'package:erek_dash/widgets/gates.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'archived_screens.dart';
import 'dayreview.dart';
import 'idea_stream/idea_stream_cont.dart';
import 'globals.dart';
import 'idea_stream/incoming_ideas.dart';
import 'interestingideas/idea_cont.dart';
import 'interestingideas/idea_list.dart';
import 'knowledge/note_cont.dart';
import 'langs/lang_cont.dart';
import 'langs/langs.dart';
import 'sequences/sequences_view.dart';
import 'tasks/task_gate.dart';
import 'tasks/tasklist.dart';
import 'tasks/visionary_tasklist.dart';
import 'value/value_cont.dart';
import 'widgets/buttons.dart';
import 'value/cash_gate.dart';

class DashLanding extends StatefulWidget {
  const DashLanding({super.key});

  @override
  State<DashLanding> createState() => _DashLandingState();
}

class _DashLandingState extends State<DashLanding> {
  final noteCont = Get.find<NoteCont>();
  final taskCont = Get.find<TaskCont>();
  final valueCont = Get.find<ValueCont>();
  final habitCont = Get.find<SequenceCont>();
  final langCont = Get.find<LangCont>();
  final ideaCont = Get.find<IdeaCont>();
  final ideaStreamCont = Get.find<IdeaStreamCont>();
  final productivityCont = Get.find<ProductivityCont>();

  GlobalKey<ScaffoldState> menuSidebarKey = GlobalKey<ScaffoldState>();

  String homeTitle = 'Erek dash';

  @override
  void initState() {
    super.initState();
    productivityCont.path =
        "${StaticHelpers.userInfo!.uid}/productivityduration";
    ideaStreamCont.path = "${StaticHelpers.userInfo!.uid}/streamOfIdeas";
    ideaCont.path = "${StaticHelpers.userInfo!.uid}/newIdeas";
    noteCont.path = "${StaticHelpers.userInfo!.uid}/note/notes";
    noteCont.labelpath = "${StaticHelpers.userInfo!.uid}/note/labels";
    langCont.path = "${StaticHelpers.userInfo!.uid}/erek_language/langs";
    habitCont.path = "${StaticHelpers.userInfo!.uid}/sequences/items";
    habitCont.progresspath = "${StaticHelpers.userInfo!.uid}/habits_journal";
    habitCont.groupPath = "${StaticHelpers.userInfo!.uid}/boxes";
    valueCont.path = "${StaticHelpers.userInfo!.uid}/values";
    taskCont.path = "${StaticHelpers.userInfo!.uid}/tasks";
    taskCont.pathOfAccomplishments =
        "${StaticHelpers.userInfo!.uid}/Accomplishments";
    ideaStreamCont.getAllNewIdeas();
    taskCont.readTasks();

    habitCont.readSequenceGroups();
    productivityCont.getCurrentDay(GlobalValues.nowStrShort);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.mainColor,
        appBar: kIsWeb
            ? AppBar(
                elevation: 0,
                toolbarHeight: 0,
              )
            : AppBar(
                title: Text(homeTitle),
                actions: [
                  Obx(() => Visibility(
                      visible: taskCont.loadingVis.value,
                      child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                          )))),
                  IconButton(
                      onPressed: () {
                        Get.to(
                            () => DayReview(theday: GlobalValues.nowStrShort));
                      },
                      icon: const Icon(Icons.local_fire_department,
                          color: Colors.white)),
                  IconButton(
                      onPressed: () {
                        menuSidebarKey.currentState?.openEndDrawer();
                      },
                      icon: const Icon(Icons.menu, color: Colors.white))
                ],
              ),
        key: menuSidebarKey,
        endDrawer: sideBar(),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 800) {
              return desktopScreen();
            } else {
              return phoneScreen();
            }
          },
        ));
  }

  Widget sideBar() {
    return SingleChildScrollView(
      child: Container(
          width: 200,
          height: Sizes.gHeight,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.to(() => const ArchivedScreens());
                      },
                      child: const Text(
                        'Archive',
                        style: TextStyle(color: Colors.black),
                      )),
                  const Divider(),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const BoxList());
                      },
                      child: const Text(
                        'Boxes',
                        style: TextStyle(color: Colors.black),
                      )),
                  const Divider(),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const Sequences());
                      },
                      child: const Text(
                        'sequences',
                        style: TextStyle(color: Colors.black),
                      )),
                  const Divider(),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const InterestingIdeas());
                      },
                      child: const Text(
                        'Interesting ideas',
                        style: TextStyle(color: Colors.black),
                      )),
                  const Divider(),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const Langs());
                      },
                      child: const Text(
                        'langs',
                        style: TextStyle(color: Colors.black),
                      )),
                        const Divider(),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const ValueHistory());
                      },
                      child: const Text(
                        'value history',
                        style: TextStyle(color: Colors.black),
                      )),
                  Orientation.landscape == true
                      ? const SizedBox()
                      : const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/idealamp.jpeg'))),
                    child: const Text('charge up'),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'configurations',
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              ),
            ),
          )),
    );
  }

  Widget desktopScreen() {
    return SizedBox(
        width: Sizes.gWidth,
        height: Sizes.gHeight,
        child: Row(
          children: [
            Expanded(flex: 1, child: sideBar()),
            Expanded(
              flex: 9,
              child: Column(
                children: [
                  Expanded(flex: 2, child: boxList()),
                  const Divider(
                    color: Colors.white,
                  ),
                  Expanded(
                      flex: 8,
                      child: Row(children: [
                        Expanded(child: mainWorkingSpace()),
                        const Expanded(
                          child: IncomingIdeas(),
                        )
                      ])),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: infoGateBtn(),
                        ),
                        Expanded(
                          flex: 3,
                          child: productivityBtn(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget phoneScreen() {
    return SizedBox(
      width: Sizes.gWidth,
      height: Sizes.gHeight - 150,
      child: Column(
        children: [
          Expanded(flex: 2, child: boxList()),
          const Divider(
            color: Colors.white,
          ),
          Expanded(
              flex: 8,
              child: DefaultTabController(
                  length: 2,
                  child: TabBarView(
                      children: [mainWorkingSpace(), const IncomingIdeas()]))),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: infoGateBtn(),
                ),
                Expanded(
                  flex: 3,
                  child: productivityBtn(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget boxList() {
    return GetX<TaskCont>(builder: (boxContlittle) {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: boxContlittle.boxList.length,
          itemBuilder: (c, i) {
            var item = boxContlittle.boxList[i];
            return InkWell(
              onTap: () async {
                taskCont.parentTask = boxContlittle.boxList[i];
                taskCont.boxName = boxContlittle.boxList[i]['task'];
                taskCont.boxId =
                    taskCont.parentId = boxContlittle.boxList[i]['id'];
                taskCont.lightTasks.value = await taskCont.classifyBoxtasks(
                    boxContlittle.boxList[i]['id'], taskCont.alllightTasks);
                //  taskCont.classifyTaskTree(boxContlittle.boxList[i]['id']);
                StaticHelpers.homeMiddleAreaType.value =
                    boxContlittle.boxList[i]['id'];
              },
              onDoubleTap: () {
                taskCont.boxId =
                    taskCont.parentId = boxContlittle.boxList[i]['id'];
                taskCont.parentTask = boxContlittle.boxList[i];
                // taskCont.getBoxTasks(boxContlittle.entryNames[i]);
                // taskCont.classifyTaskTree(boxContlittle.boxList[i]['id']);
                Get.to(() => TheTask(
                      item: item,
                    ));
              },
              child: Container(
                width: 150,
                height: 120,
                decoration: BoxDecoration(
                    image: item['imgPath'] == '' || item['imgPath'] == null
                        ? const DecorationImage(
                            image: AssetImage('assets/images/imagedefault.png'),
                            fit: BoxFit.cover)
                        : DecorationImage(
                            image: NetworkImage(item['imgPath']),
                            fit: BoxFit.cover),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                margin: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: const EdgeInsets.all(7),
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Text(
                      item['task'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }

  Widget mainWorkingSpace() {
    return GetX<TaskCont>(builder: (littleCont) {
      return Column(
        children: [
          Row(children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: InkWell(
                  onTap: () {
                    taskCont.clearSubValues();
                    switch (StaticHelpers.homeMiddleAreaType.value) {
                      case "now":
                        Get.to(() => const TaskGateNow());
                        break;
                      case "value":
                        cashGate(context, false, '');
                        break;
                      default:
                        Get.to(() => TaskGate(
                              incomingIsMoving: false,
                            ));
                    }
                  },
                  child: Center(child: GetX<TaskCont>(
                    builder: (littleCont) {
                      return Text(
                        'there is ${littleCont.lightTasks.length} tasks',
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  )),
                ),
              ),
            ),
            erekBtn('value', StaticHelpers.homeMiddleAreaType.value == "value",
                () async {
              taskCont.clearValues();
              taskCont.clearParentValues();
              taskCont.readValueList();
              StaticHelpers.homeMiddleAreaType.value = 'value';
            }),
            erekBtn('now', StaticHelpers.homeMiddleAreaType.value == "now",
                () async {
              taskCont.clearValues();
              // TODO
              // taskCont.lightTasks.value = await taskCont.classifyBoxtasks(
              //     'now', taskCont.alllightTasks);
              StaticHelpers.homeMiddleAreaType.value = 'now';
            }),
            erekBtn('outer', StaticHelpers.homeMiddleAreaType.value == "outer",
                () async {
              taskCont.clearValues();
              // TODO
              // taskCont.lightTasks.value =
              //     await taskCont.classifyBoxtasks('', taskCont.alllightTasks);
              StaticHelpers.homeMiddleAreaType.value = 'outer';
            }),
            erekBtn('all', StaticHelpers.homeMiddleAreaType.value == 'allTasks',
                () {
              taskCont.clearValues();
              taskCont.clearParentValues();
              taskCont.readTasks();
              StaticHelpers.homeMiddleAreaType.value = 'allTasks';
            }),
          ]),
          Expanded(
            child: StaticHelpers.homeMiddleAreaType.value == 'allTasks' ||
                    StaticHelpers.homeMiddleAreaType.value == 'outer' ||
                    StaticHelpers.homeMiddleAreaType.value == 'now'
                ? const TaskList()
                : StaticHelpers.homeMiddleAreaType.value == 'packagedHabits'
                    ? const RunningSequence()
                    : const TaskList(),
          )
        ],
      );
    });
  }

  Widget productivityBtn() {
    return InkWell(
      onTap: () {
        productivityGate(
            context, 'what have you done?', productivityCont.oneHourNote, () {
          productivityCont.insertProductivity();
          Navigator.of(context).pop();
        });
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        margin: const EdgeInsets.all(10),
        child:
            Center(child: GetX<ProductivityCont>(builder: (productivityCont) {
          return Text(
            productivityCont.dayProductivity.length.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 25),
          );
        })),
      ),
    );
  }

  Widget infoGateBtn() {
    return InkWell(
      onTap: () {
        ideaGate(context);
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        margin: const EdgeInsets.all(10),
        child: Center(
          child: GetX<IdeaStreamCont>(
            builder: (littleCont) {
              return Text(
                '${littleCont.ideaList.length} incomings / Write here... ',
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
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
                  ideaStreamCont.insertIdea();
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
                                  controller: ideaStreamCont.ideaTxtCnt,
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

  Object builtInDropDown(BuildContext conte) {
    return showGeneralDialog(
      context: conte,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(conte).modalBarrierDismissLabel,
      barrierColor: const Color.fromARGB(133, 0, 0, 0),
      pageBuilder: (conte, anim1, anim2) {
        return Container();
      },
    );
  }
}
