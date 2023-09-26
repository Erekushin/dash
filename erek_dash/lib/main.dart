import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'boxes/boxcont.dart';
import 'dayproductivity/productivity_cont.dart';
import 'gems/gem_cont.dart';
import 'habits/habit_cont.dart';
import 'interestingideas/idea_cont.dart';
import 'notes/note_cont.dart';
import 'idea_stream/idea_stream_cont.dart';
import 'globals.dart';
import 'home.dart';

void main() async {
  // firebase version
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
    Get.put(BoxCont(), permanent: true);
    Get.put(TaskCont(), permanent: true);
    Get.put(HabitCont(), permanent: true);
    Get.put(NoteCont(), permanent: true);
    Get.put(ProductivityCont(), permanent: true);
    Get.put(GemCont(), permanent: true);
    Get.put(IdeaCont(), permanent: true);
  }
}
