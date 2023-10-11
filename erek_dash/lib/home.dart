import 'package:erek_dash/dayproductivity/productivity_cont.dart';
import 'package:erek_dash/tasks/task_cont.dart';
import 'package:erek_dash/widgets/gates.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'archived_screens.dart';
import 'boxes/boxcont.dart';
import 'boxes/boxlist.dart';
import 'boxes/thebox.dart';
import 'dayreview.dart';
import 'habits/habit_cont.dart';
import 'idea_stream/idea_stream_cont.dart';
import 'globals.dart';
import 'habits/habit_list.dart';
import 'habits/packaged_habits.dart';
import 'idea_stream/incoming_ideas.dart';
import 'interestingideas/idea_list.dart';
import 'langs/langs.dart';
import 'tasks/box_tasks.dart';
import 'tasks/task_gate.dart';
import 'tasks/tasklist.dart';

class DashLanding extends StatefulWidget {
  const DashLanding({super.key});

  @override
  State<DashLanding> createState() => _DashLandingState();
}

class _DashLandingState extends State<DashLanding> {
  final ideaStreamCont = Get.find<IdeaStreamCont>();
  final taskCont = Get.find<TaskCont>();
  final habitCont = Get.find<HabitCont>();
  final productivityCont = Get.find<ProductivityCont>();
  final boxCont = Get.find<BoxCont>();

  GlobalKey<ScaffoldState> menuSidebarKey = GlobalKey<ScaffoldState>();
  String homeTitle = 'Erek dash ';

  @override
  void initState() {
    super.initState();
    ideaStreamCont.getAllNewIdeas();
    habitCont.allGroups();
    habitCont.getAllHabits();
    productivityCont.getCurrentDay(GlobalValues.nowStrShort);
    boxCont.allBoxes();
  }

  @override
  void dispose() {
    Erekdatabase.closeDatabase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: MyColors.mainColor,
          appBar: AppBar(
            title: Text(homeTitle),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(() => DayReview(theday: GlobalValues.nowStrShort));
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
          endDrawer: SingleChildScrollView(
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
                              Get.to(() => const Habits());
                            },
                            child: const Text(
                              'habits',
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
                                  image: AssetImage(
                                      'assets/images/idealamp.jpeg'))),
                          child: const Text('charge up'),
                        ),
                        TextButton(
                            onPressed: () {
                              configuration(context);
                            },
                            child: const Text(
                              'configurations',
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    ),
                  ),
                )),
          ),
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
                        flex: 2,
                        child: GetX<BoxCont>(builder: (boxContlittle) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: boxContlittle.boxList.length,
                              itemBuilder: (c, i) {
                                var item = boxContlittle.boxList[i];
                                String name = item['boxname'];
                                return InkWell(
                                  onTap: () {
                                    taskCont.getBoxTasks(item['id']);
                                    setState(() {
                                      GlobalValues.homeScreenType =
                                          HomeScreenType.boxTasks;
                                    });
                                  },
                                  onDoubleTap: () {
                                    Get.to(() => TheBox(
                                          item: item,
                                          id: boxContlittle.entryNames[i],
                                        ));
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 120,
                                    decoration: BoxDecoration(
                                        image: item['picture'] == ''
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/imagedefault.png'),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: NetworkImage(
                                                    item['picture']),
                                                fit: BoxFit.cover),
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    margin: const EdgeInsets.all(10),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        margin: const EdgeInsets.all(7),
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Text(
                                          item['boxname'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }),
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      Row(children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => TaskGate(
                                      incomingIsMoving: false,
                                    ));
                              },
                              child: Center(child: GetX<TaskCont>(
                                builder: (littleCont) {
                                  return Text(
                                    'there is ${littleCont.taskList.length} tasks in total / add here...',
                                    style: const TextStyle(color: Colors.white),
                                  );
                                },
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                GlobalValues.homeScreenType =
                                    HomeScreenType.allTasks;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: const Text(
                                'all',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ]),
                      Expanded(
                          flex: 7,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GlobalValues.homeScreenType ==
                                        HomeScreenType.allTasks
                                    ? const TaskList()
                                    : const SizedBox(),
                                GlobalValues.homeScreenType ==
                                        HomeScreenType.boxTasks
                                    ? const BoxTask()
                                    : const SizedBox(),
                                GlobalValues.homeScreenType ==
                                        HomeScreenType.packagedHabits
                                    ? const PackagedHabits()
                                    : const SizedBox()
                              ],
                            ),
                          )),
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
                                onTap: () {
                                  productivityGate(
                                      context,
                                      'what have you done?',
                                      productivityCont.oneHourNote, () {
                                    productivityCont.insertProductivity();
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  margin: const EdgeInsets.all(10),
                                  child: Center(child: GetX<ProductivityCont>(
                                      builder: (productivityCont) {
                                    return Text(
                                      productivityCont.dayProductivity.length
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    );
                                  })),
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
          )),
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

  Object configuration(BuildContext conte) {
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
                          height: 400,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 5, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: habitCont.groupList.length,
                              itemBuilder: (c, i) {
                                var item = habitCont.groupList[i];
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                      habitCont.currentHabitTypeId = item['id'];
                                      habitCont.packageHabits();
                                      GlobalValues.homeScreenType =
                                          HomeScreenType.packagedHabits;
                                      homeTitle = item['name'];
                                      setState(() {});
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(item['name'])),
                                  ),
                                );
                              }),
                        )
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
