import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/work_with_database.dart';
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
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white)),
        initialBinding: BindingsBuilder(() => bindInitialControllers()),
        debugShowCheckedModeBanner: false,
        home: const DashLanding());
  }

  bindInitialControllers() {
    Get.put(WorkLocalCont(), permanent: true);
  }
}
