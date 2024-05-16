import 'dart:io';
import 'package:erek_dash/security/login.dart';
import 'package:erek_dash/security/security_cont.dart';
import 'package:erek_dash/tasks/task_cont.dart';
import 'package:erek_dash/value/value_cont.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dayproductivity/productivity_cont.dart';
import 'interestingideas/idea_cont.dart';
import 'langs/lang_cont.dart';
import 'knowledge/note_cont.dart';
import 'idea_stream/idea_stream_cont.dart';
import 'globals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'sequences/sequence_cont.dart';

void main() async {
  //firebase version  erek
  try {
      if (Platform.isAndroid) {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();
        var a = await FirebaseAppCheck.instance.activate(
          androidProvider: AndroidProvider.debug
        );
        
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else if (Platform.isIOS) {
      } else if (Platform.isLinux) {
      } else {}
  } catch (e) {
    print("error during firebase initializeApp : $e");
  }

  //TODO #3
  runApp(const ErekDash());
}

class ErekDash extends StatelessWidget {
  const ErekDash({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle: const TextStyle(color: Colors.white),
                centerTitle: true,
                backgroundColor: MyColors.mainColor)),
        initialBinding: BindingsBuilder(() => bindInitialControllers()),
        debugShowCheckedModeBanner: false,
        home: const Login());
  }

  bindInitialControllers() {
    Get.put(SecurityCont(), permanent: true);
    Get.put(IdeaStreamCont(), permanent: true);
    Get.put(TaskCont(), permanent: true);
    Get.put(SequenceCont(), permanent: true);
    Get.put(NoteCont(), permanent: true);
    Get.put(ProductivityCont(), permanent: true);
    Get.put(IdeaCont(), permanent: true);
    Get.put(LangCont(), permanent: true);
    Get.put(ValueCont(), permanent: true);
  }
}
