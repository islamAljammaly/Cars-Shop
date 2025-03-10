

import 'package:cars_shop/view/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../service/fire_store.dart';
import '../model/user_model.dart';
import '../view/home_view.dart';

class AuthController extends GetxController {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  FirebaseAuth _auth = FirebaseAuth.instance;

  late String email, password, name;
  Rxn<User?> _user = Rxn<User>();

  String? get user => _user.value?.email;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void googleSignInMethod() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print(googleUser);
    GoogleSignInAuthentication googleSignInAuthentication = await googleUser!.authentication;
    final AuthCredential credential =
    GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken:  googleSignInAuthentication.accessToken
    );
    await _auth.signInWithCredential(credential).then((user) {
      saveUser(user);
      Get.offAll(HomeView());
    });
  }


  void signInWithEmailAndPassword() async {
    try {
      final credential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      if(credential.user!.emailVerified) {
      Get.offAll(HomeView());
      } else {
        Get.snackbar('Erorr', 'please verfied your email');
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error login account',
        e.toString(),
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  void createAccountWithEmailAndPassword() async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password).then((user) async {
        saveUser(user);
      });
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      Future.delayed(const Duration(seconds: 6), () {
      Get.offAll(LoginScreen());
    });
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error login account',
        e.toString(),
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
    void saveUser(UserCredential user) async {
  await FireStoreUser().addUser(UserModel(
    userId: user.user!.uid,
    email: user.user!.email!,
    name: name ?? user.user!.displayName ?? '',
    pic: '',
  ));
}
  }

  


