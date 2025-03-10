import 'package:cars_shop/model/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';


class FireStoreUser {
  final CollectionReference userCollectionRef =
      FirebaseFirestore.instance.collection('Users');
      final CollectionReference carCollectionRef =
      FirebaseFirestore.instance.collection('Cars');
      final CollectionReference favoriteCarsCollectionRef =
      FirebaseFirestore.instance.collection('FavoriteCars');
      

  Future<void> addUser(UserModel userModel) {
  // Use userId as the document ID and correctly pass the user data
  return userCollectionRef
      .doc(userModel.userId)
      .set(userModel.toJson()) // This will pass the JSON map directly
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await userCollectionRef.doc(userId).get();
      return documentSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
  Future<void> addCar(CarModel carModel) {
  // Use userId as the document ID and correctly pass the user data
  return carCollectionRef
      .doc()
      .set(carModel.toJson()) // This will pass the JSON map directly
      .then((value) => print("Car Added"))
      .catchError((error) => print("Failed to add Car: $error"));
}
void addToFavorites(CarModel car, String userId) async {
  try {
    await favoriteCarsCollectionRef
        .doc(userId)
        .collection('favorites') // Ensure this matches your structure
        .doc(car.carId) // Use car ID as document ID
        .set(car.toJson())
        .then((value) => print("Car added to favorites"))
        .catchError((error) => print("Failed to add car to favorites: $error"));
  } catch (e) {
    print("Error adding car to favorites: $e");
  }
}


Future<List<CarModel>> getCarsByUserId(String userId) async {
  try {
    QuerySnapshot querySnapshot = await carCollectionRef
        .where('userId', isEqualTo: userId)
        .get();

    // Map each document to a CarModel instance
    List<CarModel> carList = querySnapshot.docs.map((doc) {
      return CarModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    return carList;
  } catch (e) {
    print("Error fetching cars: $e");
    return [];
  }
}
Future<List<CarModel>> fetchFavoriteCars(String userId) async {
  try {
    QuerySnapshot querySnapshot = await favoriteCarsCollectionRef
        .doc(userId)
        .collection('favorites') // Ensure this matches your structure
        .get();

    List<CarModel> favoriteCarsList = querySnapshot.docs.map((doc) {
      return CarModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    
    return favoriteCarsList;
  } catch (e) {
    print("Error fetching favorite cars: $e");
    return [];
  }
}

void removeFromFavorites(CarModel car, String userId) async {
  await favoriteCarsCollectionRef
      .doc(userId)
      .collection('favorites') // Ensure this matches your structure
      .doc(car.carId)
      .delete()
      .then((value) => print("Car removed from favorites"))
      .catchError((error) => print("Failed to remove car from favorites: $error"));
}

Future<void> deleteCarFromFirestore(String carId) async {
  print("Deleting car with ID: $carId");
    try {
      await carCollectionRef.doc(carId).delete();
      print("Car deleted from Firestore successfully.");
    } catch (e) {
      print("Error deleting car from Firestore: $e");
      throw e;
    }
  }

   Future<void> updateUserName(String userId, String newName) async {
    try {
      await userCollectionRef.doc(userId).update({'name': newName});
    } catch (e) {
      print("Error updating user name: $e");
      rethrow; // Optionally, rethrow the error if you want to handle it elsewhere
    }
   }
}