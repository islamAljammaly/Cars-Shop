import 'dart:io';

import 'package:cars_shop/view/constant.dart';
import 'package:cars_shop/view/widgets/custom_text.dart';
import 'package:cars_shop/view/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_view_controller.dart';
import '../service/fire_store.dart';
import '../model/car_model.dart';
import 'details_view.dart';
import 'auth/login_screen.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_dropdown_button.dart';

class HomeView extends GetWidget<HomeViewController> {
  HomeView({super.key});
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Obx(() {
          if (controller.userModel.value == null) {
            return const CircularProgressIndicator(); 
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.09, 
                  horizontal: screenWidth * 0.05, 
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello, ${controller.userModel.value!.name}!',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, 
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'أضف سيارتك على قائمة السيارات المعروضة للبيع',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: Border.all(color: primaryColor, width: 2),
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.05),
                                child: SingleChildScrollView(
                                  child: Form(
                                    key: _formKey2,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('املأ جميع الحقول التالية'),
                                        SizedBox(height: screenHeight * 0.02),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Obx(() => CustomDropdownButton(
                                                  controller.selectedColor.value,
                                                  (value) {
                                                    controller.selectedColor.value =
                                                        value!;
                                                  },
                                                  controller.listColors
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                )),
                                                SizedBox(
                                                  width: screenWidth * 0.02,
                                                ),
                                                CustomText(
                                                  text: 'لون السيارة',
                                                )
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.02),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Obx(() => CustomDropdownButton(
                                                  controller.selectedCarType.value,
                                                  (value) {
                                                    controller.selectedCarType.value =
                                                        value!;
                                                  },
                                                  controller.listTypesCars
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                )),
                                                SizedBox(
                                                  width: screenWidth * 0.02,
                                                ),
                                                CustomText(
                                                  text: 'نوع السيارة',
                                                )
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.02),
                                        CustomTextFormField(
                                            text: 'السعر بالدولار',
                                            hint: '20000',
                                            onSave: (value) {
                                              controller.price = double.parse(value!);
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty || !value.isNum) {
                                                return 'price is required';
                                              }
                                              return null;
                                            }),
                                        SizedBox(height: screenHeight * 0.02),
                                        CustomTextFormField(
                                            text: 'رقم الواتساب للتواصل',
                                            hint: '+972',
                                            onSave: (value) {
                                              controller.number = value!;
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty || !value.isPhoneNumber) {
                                                return 'number is required';
                                              }
                                              return null;
                                            }),
                                        SizedBox(height: screenHeight * 0.02),
                                        CustomButton(
                                            onPress: () async {
                                              await controller.getImage();
                                            },
                                            text: 'ضع صورة السيارة'),
                                        SizedBox(height: screenHeight * 0.02),
                                        Obx(() {
                                          final imageFile =
                                              controller.file.value;
                                          return imageFile != null
                                              ? Container(
                                                  height: screenHeight * 0.2,
                                                  width: screenWidth * 0.4,
                                                  child: Image.file(imageFile),
                                                )
                                              : const SizedBox();
                                        }),
                                        CustomButton(
                                          onPress: () {
                                            if (_formKey2.currentState!
                                                .validate()) {
                                              _formKey2.currentState!.save();
                                              if (controller.file.value !=
                                                  null) {
                                                controller.saveCar(
                                                  controller.selectedCarType
                                                      .value,
                                                  controller.price,
                                                  controller.number,
                                                  controller.selectedColor.value,
                                                  controller.file.value!,
                                                  controller.userModel.value!
                                                      .userId,
                                                  controller.userModel.value!
                                                      .email,
                                                  controller.userModel.value!
                                                      .name,
                                                );
                                                Get.back();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'تم إضافة سيارتك للبيع'),
                                                    duration:
                                                        Duration(seconds: 5),
                                                  ),
                                                );
                                              } else {
                                                Get.back();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'لم يتم إضافة سيارتك للبيع , يرجى إضافة صورة للسيارة'),
                                                    duration:
                                                        Duration(seconds: 5),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          text: 'أضف السيارة للبيع',
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        child: Icon(Icons.add, size: screenWidth * 0.12),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: primaryColor ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          alignment: Alignment.center,
                          text: 'معرض سياراتك التي عرضتها للبيع',
                          fontSize: screenWidth * 0.05,
                          color: Colors.white),
                        ),
                      ),
                    Obx(() {
                      if (controller.cars.isEmpty) {
                        return const Center(child: Text('No cars found.'));
                      } else {
                        return SizedBox(
                          height: screenHeight * 0.4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.separated(
                              itemCount: controller.cars.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                CarModel car = controller.cars[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(DetailsView(
                                      car: controller.cars[index],
                                    ));
                                  },
                                  child: Container(
                                    width: screenWidth * 0.4,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.grey.shade100,
                                          ),
                                          child: Container(
                                            height: screenHeight * 0.3,
                                            width: screenWidth * 0.4,
                                            child: Image.network(
                                              car.image,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.02),
                                        Row(
                                          children: [
                                            CustomText(
                                              text: car.type,
                                              alignment: Alignment.bottomLeft,
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                text: '${car.price}',
                                                color: const Color.fromARGB(
                                                    255, 14, 118, 81),
                                                alignment:
                                                    Alignment.bottomRight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: screenWidth * 0.05),
                            ),
                          ),
                        );
                      }
                    }),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: primaryColor ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          alignment: Alignment.center,
                          text: 'قائمة السيارات المفضلة لديك',
                          fontSize: screenWidth * 0.05,
                          color: Colors.white),
                        ),
                      ),
                    Obx(() {
                      if (controller.favoritesCars.isEmpty) {
                        return const Center(child: Text('No favorite cars found.'));
                      } else {
                        return SizedBox(
                          height: screenHeight * 0.4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.separated(
                              itemCount: controller.favoritesCars.length,
                              scrollDirection: Axis.horizontal,
                                                            itemBuilder: (context, index) {
                                CarModel car = controller.favoritesCars[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(DetailsView(
                                      car: controller.favoritesCars[index],
                                    ));
                                  },
                                  child: Container(
                                    width: screenWidth * 0.4,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.grey.shade100,
                                          ),
                                          child: Container(
                                            height: screenHeight * 0.3,
                                            width: screenWidth * 0.4,
                                            child: Image.network(
                                              car.image,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.02),
                                        Row(
                                          children: [
                                            CustomText(
                                              text: car.type,
                                              alignment: Alignment.bottomLeft,
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                text: '${car.price}',
                                                color: const Color.fromARGB(
                                                    255, 14, 118, 81),
                                                alignment:
                                                    Alignment.bottomRight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: screenWidth * 0.05),
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
