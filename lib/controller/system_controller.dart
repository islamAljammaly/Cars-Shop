import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';
import '../service/fire_store.dart';

class SystemController extends GetxController {
  Rxn<User?> _user = Rxn<User>();
  Rxn<UserModel?> userModel = Rxn<UserModel?>();
  @override
void onInit() {
  super.onInit();
  _user.value = FirebaseAuth.instance.currentUser; 
  ever(_user, (_) => fetchUserData()); 
  fetchUserData(); 
}

  Future<void> fetchUserData() async {
  if (_user.value != null) {
    final userId = _user.value!.uid;
    try {
      final userData = await FireStoreUser().getUser(userId);
      print('Fetched user data: $userData'); 
      if (userData != null) {
        userModel.value = UserModel.fromJson(userData);
      } else {
        userModel.value = null; 
      }
    } catch (e) {
      print('Error fetching user data: $e'); 
      userModel.value = null; 
    }
  }
}
void showEditDialog(BuildContext context, String? currentName) {
    final TextEditingController nameController = TextEditingController(text: currentName);
 showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); 
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  await _updateUserName(newName); 
                  Get.back();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserName(String newName) async {
    if (userModel.value != null) {
      final userId = _user.value!.uid;
      await FireStoreUser().updateUserName(userId, newName);
      await fetchUserData();
    }
  }
}