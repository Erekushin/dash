import 'package:erek_dash/globals.dart';
import 'package:erek_dash/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

import '../widgets/snacks.dart';

class SecurityCont extends GetxController {
  RxBool loadingVis = false.obs;
  TextEditingController inputtxt = TextEditingController();

  getUid() async {
    loadingVis.value = true;
    GoogleSignInAccount? gUser;
    try {
      gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);
      var loginResponse =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (loginResponse.user != null) {
        StaticHelpers.userInfo = loginResponse.user;
        getIn();
      } else {
        print('I think there is no user');
      }
      // Rest of your code
    } catch (e, stackTrace) {
      Snacks.freeSnack(e.toString());
      print('Error during Google Sign-In: $e\n$stackTrace');
    }
  }

  getIn() async {
    try {
      DatabaseEvent a = await StaticHelpers.databaseReference
          .child(StaticHelpers.userInfo!.uid)
          .once();
      if (!a.snapshot.exists) {
        registerUser();
      }
      loadingVis.value = false;
      Get.to(() => const DashLanding());
    } catch (e) {
      print(e);
    }
  }

  registerUser() {
    try {
      StaticHelpers.databaseReference
          .child(StaticHelpers.userInfo!.uid)
          .set(StaticHelpers.userInfo!.displayName)
          .whenComplete(() {
        Snacks.savedSnack();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

// uid aa avah process tusdaa negent avchih yum bol bvrtgvvleh esvel nevtreh gesen
// 2 songolt l bgaa tehee user bgaa vgvvg ni harah heregtei gesen vg
}
