import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'boxes/boxcont.dart';
import 'dayproductivity/productivity_cont.dart';
import 'habits/habit_cont.dart';
import 'interestingideas/idea_cont.dart';
import 'langs/lang_cont.dart';
import 'notes/note_cont.dart';
import 'idea_stream/idea_stream_cont.dart';
import 'globals.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // firebase version //last
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyDhqXuEF2ExqRx_g4p2rjhP6JpCqp6bsno',
    appId: '1:518470648235:web:0aa6818825019db0ead2ee',
    messagingSenderId: '518470648235',
    databaseURL:
        "https://erek-dashboard-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: 'erek-dashboard',
    storageBucket: "erek-dashboard.appspot.com",
  ));
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
    Get.put(IdeaCont(), permanent: true);
    Get.put(LangCont(), permanent: true);
  }
}
