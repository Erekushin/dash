import 'package:get/get.dart';

import '../globals.dart';

class ConfigurationCont extends GetxController {
  RxInt habitTypeId = 0.obs;
  DateTime now1 = DateTime.now();

  ConfigurationCont() {
    DateTime now = DateTime(now1.year, now1.month, now1.day, 11, 0, 0);
    for (int i = 0; i < GlobalStatics.habitType.length; i++) {
      var item = GlobalStatics.habitType[i];
      if (now.hour >= item['upperthat'] && now.hour <= item['downerthat']) {
        habitTypeId.value = item;
        print('current id is ${habitTypeId}');
      }
    }
  }
}
