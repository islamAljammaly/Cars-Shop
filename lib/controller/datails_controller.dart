
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../service/fire_store.dart';
import '../model/car_model.dart';
class DetailsController extends GetxController {
  // Add this to your controller
  RxBool isFavorite = false.obs;
 
  void checkIfFavorite(CarModel car, String userId) async {
    try {
      final favoriteCarsList = await FireStoreUser().fetchFavoriteCars(userId);
      isFavorite.value = favoriteCarsList.any((favCar) => favCar.carId == car.carId);
    } catch (e) {
      print("Error checking favorite status: $e");
    }
  }

  Future<void> deleteCar(CarModel car) async {
    try {
      // Assuming `cars` is the collection where cars are stored
      await FireStoreUser().deleteCarFromFirestore(car.carId); // Ensure this method correctly interacts with Firestore
      print("Car deleted successfully");
    } catch (e) {
      print("Error deleting car: $e");
      rethrow;
    }
  }
}
