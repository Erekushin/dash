import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'conf_cont.dart';
import '../globals.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration>
    with TickerProviderStateMixin {
  Duration duration = const Duration(milliseconds: 370);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: GetX<ConfigurationCont>(builder: (littleCont) {
            return Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('habit type'),
                      DropdownButton<int>(
                          value: littleCont.habitTypeId.value,
                          items: [
                            for (var item in GlobalStatics.habitType)
                              DropdownMenuItem(
                                value: item['id'],
                                child: Text(item['name']),
                              ),
                          ],
                          onChanged: (value) {
                            littleCont.habitTypeId.value = value!;
                          })
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
