import 'package:cars_shop/controller/auth_controller.dart';
import 'package:cars_shop/view/auth/register_view.dart';
import 'package:cars_shop/view/widgets/custom_button.dart';
import 'package:cars_shop/view/widgets/custom_social_button.dart';
import 'package:cars_shop/view/widgets/custom_text.dart';
import 'package:cars_shop/view/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant.dart';

class LoginScreen extends GetWidget<AuthController> {
  LoginScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.06,
          right: screenWidth * 0.05,
          left: screenWidth * 0.05,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Welcome,",
                      fontSize: screenWidth * 0.08, 
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RegisterView());
                      },
                      child: CustomText(
                        text: "Sign Up",
                        color: primaryColor,
                        fontSize: screenWidth * 0.045, 
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomText(
                  text: 'Sign in to Continue',
                  fontSize: screenWidth * 0.035,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                CustomTextFormField(
                  text: 'Email',
                  hint: 'islam1742000@gmail.com',
                  onSave: (value) {
                    controller.email = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                CustomTextFormField(
                  text: 'Password',
                  hint: '**********',
                  onSave: (value) {
                    controller.password = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                GestureDetector(
                  onTap: () async {
                    _formKey.currentState?.save();

                    if (controller.email != null &&
                        controller.email.isNotEmpty) {
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: controller.email);
                      } catch (e) {
                        Get.snackbar('Error', 'your email is invalid');
                      }
                      Get.snackbar('Reset Password',
                          'لقد قمنا بإرسال رابط على ايميلك حتى تتمكن من تغيير كلمة السر الخاصة بك');
                    } else {
                      Get.snackbar('Error', 'Please enter your email to reset password');
                    }
                  },
                  child: CustomText(
                    text: 'Forgot Password?',
                    fontSize: screenWidth * 0.035, 
                    alignment: Alignment.topRight,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                CustomButton(
                  onPress: () {
                    _formKey.currentState?.save();

                    if (_formKey.currentState!.validate()) {
                      controller.signInWithEmailAndPassword();
                    }
                  },
                  text: 'SIGN IN',
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                CustomText(
                  text: '-OR-',
                  alignment: Alignment.center,
                  fontSize: screenWidth * 0.035, 
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                CustomButtonSocial(
                  text: 'Sign In with Google',
                  imageName: 'assets/google.png',
                  onPress: () {
                    controller.googleSignInMethod();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
