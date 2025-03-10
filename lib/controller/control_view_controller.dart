import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../view/home_view.dart';
import '../view/search_view.dart';
import '../view/system_view.dart';

class ControlViewController extends GetxController {
  int _navigatorValue = 0;
  PageController pageController = PageController(); // Add PageController

  get navigatorValue => _navigatorValue;

  Widget currentScreen = HomeView();

  // Method to change selected value and jump to corresponding page
  void changeSelectedValue(int selectedValue) {
    _navigatorValue = selectedValue;
    pageController.jumpToPage(selectedValue); // Update the page controller
    update();
  }

  // Method to handle page swipes
  void onPageChanged(int index) {
    _navigatorValue = index;
    update();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
