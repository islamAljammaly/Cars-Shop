import 'package:cars_shop/controller/search_controller.dart';
import 'package:cars_shop/view/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'details_view.dart';

class SearchView extends GetWidget<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Cars"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Get screen width and height
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    color: Colors.grey.shade200,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.searchTextController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: screenWidth * 0.07,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.trim().isEmpty) {
                            controller.isTyping.value = false;
                            controller.fetchCars(); 
                          } else {
                            controller.isTyping.value = true;
                            controller.suggestions.value = controller.carTypes
                                .where((type) => type.toLowerCase().contains(value.trim().toLowerCase()))
                                .toList();

                            controller.fetchSpecificCars(value.trim()); 
                          }
                        },
                      ),
                      Obx(() {
                        if (controller.isTyping.value && controller.suggestions.isNotEmpty) {
                          return Container(
                            height: screenHeight * 0.12,
                            child: ListView.builder(
                              itemCount: controller.suggestions.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(controller.suggestions[index], style: TextStyle(fontSize: screenWidth * 0.045)),
                                  onTap: () {
                                    controller.searchTextController.text = controller.suggestions[index];
                                    controller.fetchSpecificCars(controller.suggestions[index]);
                                    controller.isTyping.value = false; 
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.cars.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.cars.isEmpty) {
                    return const Center(child: Text("No cars found."));
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.cars.length + 1, 
                    itemBuilder: (context, index) {
                      if (index == controller.cars.length) {
                        return Obx(() => controller.hasMore.value
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink());
                      }

                      var car = controller.cars[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(DetailsView(
                                car: controller.cars[index],
                              ));
                            },
                            child: ListTile(
                              leading: Container(
                                width: screenWidth * 0.25, 
                                height: screenWidth * 0.25, 
                                child: Image.network(
                                  car.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                car.type,
                                style: TextStyle(fontSize: screenWidth * 0.045),
                              ),
                              subtitle: Text(
                                '${car.price}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Color.fromARGB(255, 12, 132, 66),
                                ),
                              ),
                            ),
                          ),
                          if (index != controller.cars.length - 1)
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
