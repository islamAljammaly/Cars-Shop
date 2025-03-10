import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cars_shop/model/car_model.dart';

class SearchController extends GetxController {
  var cars = <CarModel>[].obs; // List to hold cars
  var isLoading = false.obs;
  DocumentSnapshot? lastDocument;
  var hasMore = true.obs;
  ScrollController scrollController = ScrollController();
  final TextEditingController searchTextController = TextEditingController();
  RxList<String> suggestions = <String>[].obs; // List to hold search suggestions
  RxBool isTyping = false.obs; // Detect if user is typing

  // Sample list of car types for suggestions (this can be fetched from Firebase as well)
  final List<String> carTypes = [
    "كيا",
    "هونداي",
    "تويوتا",
    "مرسيدس",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchCars(); // Fetch initial cars when the controller is initialized

    // Listen to scroll events and load more cars when the user scrolls near the bottom
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && hasMore.value) {
        fetchMoreCars();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose(); // Dispose the controller when not needed
    super.onClose();
  }

  // Method to fetch all cars with pagination
  Future<void> fetchCars() async {
    if (isLoading.value) return;

    isLoading.value = true;
    hasMore.value = true; // Reset hasMore to true for new search
    
    Query query = FirebaseFirestore.instance.collection('Cars').limit(10);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      var newCars = querySnapshot.docs.map((doc) {
        return CarModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      cars.assignAll(newCars); // Replace the existing cars with new ones
      lastDocument = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      if (newCars.length < 10) {
        hasMore.value = false; // No more data if less than 10 cars are fetched
      }
    }

    isLoading.value = false;
  }

  // Method to fetch more cars when scrolling
  Future<void> fetchMoreCars() async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;

    Query query = FirebaseFirestore.instance.collection('Cars').limit(10);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      var newCars = querySnapshot.docs.map((doc) {
        return CarModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      cars.addAll(newCars); // Add new cars to the list
      lastDocument = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      if (newCars.length < 10) {
        hasMore.value = false; // No more data if less than 10 cars are fetched
      }
    }

    isLoading.value = false;
  }

  // Method to fetch specific cars based on search criteria
  // Method to fetch specific cars based on search criteria
// Method to fetch specific cars based on search criteria
Future<void> fetchSpecificCars(String value) async {
  if (isLoading.value) return;

  isLoading.value = true;
  hasMore.value = false;
  
  if (value.endsWith('\$')) {
    value = value.substring(0, value.length - 1); // Remove trailing '$'
  }

  if (int.tryParse(value) != null) {
    // If it's a number, treat the price as a string and fetch cars where the price starts with the input value
    Query query = FirebaseFirestore.instance
        .collection('Cars')
        .where('price', isLessThanOrEqualTo: value) // String range search
        .limit(10);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      var newCars = querySnapshot.docs.map((doc) {
        return CarModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      cars.assignAll(newCars); // Replace the existing cars with new ones
      lastDocument = null; // No more documents for specific search
    } else {
      cars.clear(); // Clear the list if no cars are found
    }

    isLoading.value = false;
  } else {
    // Otherwise, search by type as before
    Query query = FirebaseFirestore.instance
        .collection('Cars')
        .where('type', isEqualTo: value)
        .limit(10);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      var newCars = querySnapshot.docs.map((doc) {
        return CarModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      cars.assignAll(newCars); // Replace the existing cars with new ones
      lastDocument = null; // No more documents for specific search
    } else {
      cars.clear(); // Clear the list if no cars are found
    }

    isLoading.value = false;
  }
}

}
