import 'package:erek_dash/globals.dart';
import 'package:erek_dash/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/snacks.dart';

class SecurityCont extends GetxController {
  TextEditingController inputtxt = TextEditingController();

  getUid() async {
    GoogleSignInAccount? gUser;
    try {
      gUser = await GoogleSignIn().signIn();
      // Rest of your code
    } catch (e, stackTrace) {
      print('Error during Google Sign-In: $e\n$stackTrace');
    }

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
  }
}

getIn() async {
  try {
    DatabaseEvent a = await StaticHelpers.databaseReference
        .child("${StaticHelpers.userInfo!.uid}/name")
        .once();
    if (!a.snapshot.exists) {
      registerUser();
    }
    Get.to(() => const DashLanding());
  } catch (e) {
    print(e);
  }
}

registerUser() {
  try {
    StaticHelpers.databaseReference
        .child('${StaticHelpers.userInfo!.uid}/name')
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
