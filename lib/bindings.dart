import 'package:cars_shop/controller/control_view_controller.dart';
import 'package:cars_shop/controller/datails_controller.dart';
import 'package:cars_shop/controller/search_controller.dart';
import 'package:get/get.dart';

import 'controller/auth_controller.dart';
import 'controller/home_view_controller.dart';
import 'controller/system_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => ControlViewController());
    Get.lazyPut(() => HomeViewController());
    Get.lazyPut(() => DetailsController());
    Get.lazyPut(() => SearchController());
    Get.lazyPut(() => SystemController());
  }
}