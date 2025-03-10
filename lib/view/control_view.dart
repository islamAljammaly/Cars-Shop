import 'package:cars_shop/controller/control_view_controller.dart';
import 'package:cars_shop/view/search_view.dart';
import 'package:cars_shop/view/system_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import 'home_view.dart';
import 'auth/login_screen.dart';

class ControlView extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (Get.find<AuthController>().user != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? GetBuilder<ControlViewController>(
              builder: (controller) => Scaffold(
                body: PageView(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.onPageChanged(index);
                  },
                  children: [
                    HomeView(),
                    SearchView(),
                    SystemView(),
                  ],
                ),
                bottomNavigationBar: bottomNavigationBar(),
              ),
            )
          : LoginScreen();
    });
  }

  Widget bottomNavigationBar() {
    return GetBuilder<ControlViewController>(
      init: ControlViewController(),
      builder: (controller) => BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text("Home"),
            ),
            label: '',
            icon: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Icon(Icons.home),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text("Search"),
            ),
            label: '',
            icon: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Icon(Icons.search),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text("System"),
            ),
            label: '',
            icon: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Icon(Icons.settings),
            ),
          ),
        ],
        currentIndex: controller.navigatorValue,
        onTap: (index) {
          controller.changeSelectedValue(index); 
        },
        elevation: 0,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.grey.shade50,
      ),
    );
  }
}
