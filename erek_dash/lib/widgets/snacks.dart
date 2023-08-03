import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snacks {
  static savedSnack() {
    Get.snackbar('😇', 'saved',
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        duration: const Duration(seconds: 1));
  }

  static deleteSnack() {
    Get.snackbar('😇', 'deleted',
        colorText: Colors.white,
        backgroundColor: const Color.fromARGB(255, 120, 12, 175),
        duration: const Duration(seconds: 1));
  }

  static chackSnack() {
    Get.snackbar('😇', 'nice job',
        colorText: Colors.white,
        backgroundColor: const Color.fromARGB(255, 120, 12, 175),
        duration: const Duration(seconds: 1));
  }

  static updatedSnack() {
    Get.snackbar('😇', 'updated',
        colorText: Colors.white,
        backgroundColor: const Color.fromARGB(255, 120, 12, 175),
        duration: const Duration(seconds: 1));
  }

  static errorSnack(Object error) {
    Get.snackbar('😇', error.toString(),
        colorText: Colors.white,
        backgroundColor: const Color.fromARGB(255, 255, 41, 41),
        duration: const Duration(seconds: 1));
  }

  static warningSnack(String msj) {
    Get.snackbar('😇', msj,
        colorText: Colors.white,
        backgroundColor: const Color.fromARGB(255, 235, 190, 9),
        duration: const Duration(seconds: 1));
  }
}
