import 'package:cars_shop/service/fire_store.dart';
import 'package:cars_shop/model/car_model.dart';
import 'package:cars_shop/view/constant.dart';
import 'package:cars_shop/view/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/datails_controller.dart';

class DetailsView extends GetWidget<DetailsController> {
  final CarModel car;
  final DetailsController controller = Get.find();

  DetailsView({required this.car}) {
    // Fetch userId and check if the car is a favorite
    final userId = FirebaseAuth.instance.currentUser!.uid;
    controller.checkIfFavorite(car, userId);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var user = FirebaseAuth.instance.currentUser; 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight * 0.35,
              child: Image.network(
                car.image,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    children: [
                      CustomText(
                        text: car.type,
                        fontSize: screenWidth * 0.065,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            width: screenWidth * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomText(
                                  text: 'Price',
                                  fontSize: screenWidth * 0.04,
                                ),
                                CustomText(
                                  text: '${car.price}',
                                  fontSize: screenWidth * 0.04,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            width: screenWidth * 0.44,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomText(
                                  text: 'Color',
                                  fontSize: screenWidth * 0.04,
                                ),
                                CustomText(
                                  text: car.color,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomText(
                        text: 'Details',
                        fontSize: screenWidth * 0.045,
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.email),
                              SizedBox(width: screenWidth * 0.02),
                              CustomText(
                                text: car.email,
                                fontSize: screenWidth * 0.035,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: screenWidth * 0.02),
                              CustomText(
                                text: car.name,
                                fontSize: screenWidth * 0.035,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: screenWidth * 0.02),
                          CustomText(
                            text: car.number,
                            fontSize: screenWidth * 0.035,
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: [
                          Obx(() {
                            return IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: controller.isFavorite.value
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              onPressed: () {
                                var user = FirebaseAuth.instance.currentUser;
                                if (controller.isFavorite.value) {
                                  // Remove from favorites
                                  FireStoreUser().removeFromFavorites(
                                      car, user!.uid);
                                } else {
                                  // Add to favorites
                                  FireStoreUser()
                                      .addToFavorites(car, user!.uid);
                                }
                                controller.isFavorite.value =
                                    !controller.isFavorite.value; 
                              },
                            );
                          }),
                          SizedBox(width: screenWidth * 0.02),
                          CustomText(
                            text: 'أضف السيارة إلى قائمة المفضلة لديك',
                            fontSize: screenWidth * 0.045,
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.002),
                      if (user != null && car.userId == user.uid)
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                bool confirmed = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Car'),
                                      content: Text(
                                          'Are you sure you want to delete this car?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmed == true) {
                                  await controller.deleteCar(car);
                                  Get.back(); // Go back after deleting
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Car deleted successfully')),
                                  );
                                }
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            CustomText(
                              text: 'حذف هذه السيارة',
                              fontSize: screenWidth * 0.045,
                              alignment: Alignment.center,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
