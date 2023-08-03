import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'configuration/conf_cont.dart';
import 'habits/habit_cont.dart';
import 'notes/note_cont.dart';
import 'idea_stream/idea_stream_cont.dart';
import 'globals.dart';
import 'home.dart';

void main() {
  runApp(const ErekDash());
}

class ErekDash extends StatelessWidget {
  const ErekDash({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                centerTitle: true, backgroundColor: MyColors.mainColor)),
        initialBinding: BindingsBuilder(() => bindInitialControllers()),
        debugShowCheckedModeBanner: false,
        home: const DashLanding());
  }

  bindInitialControllers() {
    Get.put(IdeaStreamCont(), permanent: true);
    Get.put(ConfigurationCont(), permanent: true);
    Get.put(TaskCont(), permanent: true);
    Get.put(HabitCont(), permanent: true);
    Get.put(NoteCont(), permanent: true);
  }
}
