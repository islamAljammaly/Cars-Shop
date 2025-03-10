import 'package:cars_shop/view/widgets/custom_button.dart';
import 'package:cars_shop/view/widgets/custom_text.dart';
import 'package:cars_shop/view/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import 'login_screen.dart';

class RegisterView extends GetWidget<AuthController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.off(LoginScreen());
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Get screen width and height
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.05,
              horizontal: screenWidth * 0.05,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Sign Up,",
                      fontSize: screenWidth * 0.08, 
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    CustomTextFormField(
                      text: 'Name',
                      hint: 'Pesa',
                      onSave: (value) {
                        controller.name = value!;
                      },
                      validator: (value) {
                        if (value == null) {
                          print("ERROR");
                        }
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    CustomTextFormField(
                      text: 'Email',
                      hint: 'iamdavid@gmail.com',
                      onSave: (value) {
                        controller.email = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'error';
                        }
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    CustomTextFormField(
                      text: 'Password',
                      hint: '**********',
                      onSave: (value) {
                        controller.password = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'error';
                        } else if (value.length < 7) {
                          return 'كلمة السر ضعيفة جداً';
                        }
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    CustomButton(
                      onPress: () {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          controller.createAccountWithEmailAndPassword();
                          Get.snackbar(
                            'Email verification',
                            'يرجى التوجه الى ايميلك والضغط على الرابط الذي قمنا بإرساله للتحقق حتى تتمكن من الدخول الى حسابك',
                          );
                        }
                      },
                      text: 'SIGN UP',
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
