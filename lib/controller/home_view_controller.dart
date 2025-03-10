import 'dart:io';


import 'package:cars_shop/model/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../service/fire_store.dart';
import '../model/user_model.dart';

class HomeViewController extends GetxController {
  Rxn<User?> _user = Rxn<User>();
  Rxn<UserModel?> userModel = Rxn<UserModel?>();
  List<String> listColors = ['أزرق', 'أحمر', 'أسود', 'أبيض', 'فضي'];
  List<String> listTypesCars = ['كيا', 'هونداي', 'تويوتا', 'مرسيدس'];
  RxString selectedColor = 'أزرق'.obs;
  RxString selectedCarType = 'كيا'.obs;
  Rx<File?> file = Rx<File?>(null); // Use Rx<File?> for reactivity
  late String number;
  late double price;

  // Reactive list to hold the user's cars
  RxList<CarModel> cars = <CarModel>[].obs;
  RxList<CarModel> favoritesCars = <CarModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, (_) => fetchUserData());
    ever(_user, (_) => setupRealTimeUpdates()); // Fetch cars when user state changes
  }

  Future<void> fetchUserData() async {
    if (_user.value != null) {
      final userId = _user.value!.uid;
      final userData = await FireStoreUser().getUser(userId);
      if (userData != null) {
        userModel.value = UserModel.fromJson(userData);
      }
    }
  }

  void fetchUserCars() {
  if (_user.value != null) {
    final userId = _user.value!.uid;
    FireStoreUser().getCarsByUserId(userId).then((carList) {
      cars.assignAll(carList);
    });

    FireStoreUser().fetchFavoriteCars(userId).then((favoriteCarsList) {
      favoritesCars.assignAll(favoriteCarsList);
    });
  }
}

void setupRealTimeUpdates() {
  if (_user.value != null) {
    final userId = _user.value!.uid;

    FireStoreUser().carCollectionRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((querySnapshot) {
      List<CarModel> carList = querySnapshot.docs.map((doc) {
        return CarModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      cars.assignAll(carList);
    });

    FireStoreUser().favoriteCarsCollectionRef
        .doc(userId)
        .collection('favorites') // Ensure this matches your structure
        .snapshots()
        .listen((querySnapshot) {
      List<CarModel> favoriteCarsList = querySnapshot.docs.map((doc) {
        return CarModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      favoritesCars.assignAll(favoriteCarsList);
    });

    FireStoreUser().userCollectionRef.doc(userId).snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        userModel.value = UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
      }
    });
  }
}


  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      file.value = File(image.path); // Update the reactive variable
    }
  }
  

  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = basename(imageFile.path);
      Reference ref = FirebaseStorage.instance.ref().child('car_images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return ''; // Return an empty string or handle this error appropriately
    }
  }

  void saveCar(String type, double price, String number, String color, File image, String userId, String email, String name) async {
    try {
      String imageUrl = await uploadImage(image);
      if (imageUrl.isEmpty) {
        print('Image URL is empty, car will not be saved.');
        return;
      }

      CarModel newCar = CarModel(
        carId: FireStoreUser().carCollectionRef.doc().id,
        type: type,
        number: number,
        color: color,
        price: price,
        image: imageUrl,
        email: email,
        userId: userId,
        name: name,
      );

      await FireStoreUser().addCar(newCar);

      cars.add(newCar); // Update the reactive list with the new car

      print('Car successfully saved with image URL: $imageUrl');
    } catch (e) {
      print('Error saving car: $e');
    }
  }
}
