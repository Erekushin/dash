import 'dart:io';

import 'package:erek_dash/security/login.dart';
import 'package:erek_dash/security/security_cont.dart';
import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'boxes/boxcont.dart';
import 'dayproductivity/productivity_cont.dart';
import 'interestingideas/idea_cont.dart';
import 'langs/lang_cont.dart';
import 'knowledge/note_cont.dart';
import 'idea_stream/idea_stream_cont.dart';
import 'globals.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

import 'sequences/sequence_cont.dart';

void main() async {
  //firebase version
  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDhqXuEF2ExqRx_g4p2rjhP6JpCqp6bsno",
            authDomain: "erek-dashboard.firebaseapp.com",
            databaseURL:
                "https://erek-dashboard-default-rtdb.asia-southeast1.firebasedatabase.app",
            projectId: "erek-dashboard",
            storageBucket: "erek-dashboard.appspot.com",
            messagingSenderId: "518470648235",
            appId: "1:518470648235:web:0aa6818825019db0ead2ee",
            measurementId: "G-N13TD279NY"));
  } else {
    if (Platform.isAndroid) {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else if (Platform.isIOS) {
      print('Running on iOS');
    } else if (Platform.isLinux) {
      print('Running on Linux');
    } else {
      print('Running on an unknown platform');
    }
  }

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
        home: const Login());
  }

  bindInitialControllers() {
    Get.put(SecurityCont(), permanent: true);
    Get.put(IdeaStreamCont(), permanent: true);
    Get.put(BoxCont(), permanent: true);
    Get.put(TaskCont(), permanent: true);
    Get.put(SequenceCont(), permanent: true);
    Get.put(NoteCont(), permanent: true);
    Get.put(ProductivityCont(), permanent: true);
    Get.put(IdeaCont(), permanent: true);
    Get.put(LangCont(), permanent: true);
  }
}
