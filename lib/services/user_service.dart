import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  Future<UserModel?> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!userDoc.exists) {
      return null;
    }

    final data = userDoc.data();
    if (data == null) {
      return null;
    }

    return UserModel.fromJson(data);
  }

  Future<void> updateUserData(UserModel userModel) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    // Fetch the current data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      return;
    }

    // Get the current data as a map
    Map<String, dynamic> currentData = userDoc.data() as Map<String, dynamic>;

    // Prepare a map to hold the updated fields
    Map<String, dynamic> updatedData = {};

    // Compare each field and update only if it's different
    if (userModel.name != currentData['name']) {
      updatedData['name'] = userModel.name;
    }
    if (userModel.email != currentData['email']) {
      updatedData['email'] = userModel.email;
    }
    if (userModel.team != currentData['team']) {
      updatedData['team'] = userModel.team;
    }
    if (userModel.experience != currentData['experience']) {
      updatedData['experience'] = userModel.experience;
    }
    if (userModel.contact != currentData['contact']) {
      updatedData['contact'] = userModel.contact;
    }
    if (userModel.position != currentData['position']) {
      updatedData['position'] = userModel.position;
    }
    if (userModel.favouriteTeam != currentData['favourite_team']) {
      updatedData['favourite_team'] = userModel.favouriteTeam;
    }
    if (userModel.imageUrlProfile != currentData['imageUrlProfile']) {
      updatedData['imageUrlProfile'] = userModel.imageUrlProfile;
    }

    // If there are updates, apply them
    if (updatedData.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updatedData);
    }
  }
}
