import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snacks {
  static freeSnack(String txt) {
    Get.snackbar('😇', txt,
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        duration: const Duration(seconds: 1));
  }

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

  static checkSnack() {
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
    Get.snackbar('😞', '',
        colorText: Colors.black,
        messageText: Text(
          error.toString(),
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        shouldIconPulse: true,
        icon: const Icon(Icons.warning),
        backgroundColor: const Color.fromARGB(255, 249, 153, 153),
        duration: const Duration(seconds: 5));
  }

  static warningSnack(String msj) {
    Get.snackbar('😇', msj,
        colorText: Colors.white,
        backgroundColor: const Color.fromARGB(255, 235, 190, 9),
        duration: const Duration(seconds: 1));
  }
}
