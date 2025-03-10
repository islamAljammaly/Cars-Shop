import 'package:cars_shop/controller/system_controller.dart';
import 'package:cars_shop/view/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth/login_screen.dart';

class SystemView extends GetWidget<SystemController> {
  const SystemView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.12, 
          left: screenWidth * 0.02, 
          right: screenWidth * 0.02, 
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              alignment: Alignment.centerLeft,
              text: 'Name',
              fontSize: screenWidth * 0.05, 
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: screenHeight * 0.01), 
            Obx(() {
              if (controller.userModel.value == null) {
                return Center(child: Text('Loading...'));
              }
              final user = controller.userModel.value!;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user.name ?? 'No Name',
                    style: TextStyle(fontSize: screenWidth * 0.045), 
                  ),
                  IconButton(
                    onPressed: () => controller.showEditDialog(context, user.name),
                    icon: Icon(
                      Icons.edit,
                      size: screenWidth * 0.07, 
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: screenHeight * 0.03),
            CustomText(
              alignment: Alignment.centerLeft,
              text: 'Email',
              fontSize: screenWidth * 0.05, 
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: screenHeight * 0.015),
            Obx(() {
              if (controller.userModel.value == null) {
                return Center(child: Text('Loading...'));
              }
              final user = controller.userModel.value!;
              return CustomText(
                text: user.email ?? 'No Email',
                alignment: Alignment.centerLeft,
                fontSize: screenWidth * 0.045, 
              );
            }),
            SizedBox(height: screenHeight * 0.07),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(LoginScreen());
                  },
                  child: Text(
                    'Sign out',
                    style: TextStyle(fontSize: screenWidth * 0.045,fontWeight: FontWeight.bold ), 
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                CustomText(
                  text: ': لتسجيل الخروج اضغط على',
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            CustomText(
              text: ': للاستفسار والدعم الفني يرجى التواصل واتساب على الرقم',
              fontSize: screenWidth * 0.045, 
              alignment: Alignment.centerRight,
            ),
            SizedBox(height: screenHeight * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.contact_phone,
                  size: screenWidth * 0.07, 
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                CustomText(
                  text: '+970598347668',
                  alignment: Alignment.centerRight,
                  fontSize: screenWidth * 0.045, 
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomText(
              text: ': أو عبر الايميل التالي',
              alignment: Alignment.centerRight,
              fontSize: screenWidth * 0.045, 
            ),
            SizedBox(height: screenHeight * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.email,
                  size: screenWidth * 0.07, 
                ),
                SizedBox(
                  width: screenWidth * 0.02, 
                ),
                CustomText(
                  text: 'islam1742000@gmail.com',
                  alignment: Alignment.centerRight,
                  fontSize: screenWidth * 0.045, 
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
