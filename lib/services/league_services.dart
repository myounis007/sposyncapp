// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/createleague_model.dart';

class LeagueServices {
// add league
  Future<void> addLeagueToFirestore(Createleague league) async {
    // Get a reference to the Firestore collection
    CollectionReference leagues =
        FirebaseFirestore.instance.collection('leagues');

    // Add a new document with the league data
    try {
      await leagues.add(league.toJson());
      print('League added to Firestore');
    } catch (e) {
      print('Failed to add league: $e');
    }
  }

// to  delete league
  Future<void> deleteLeague(Createleague league, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('leagues')
          .doc(league.id)
          .delete();
      log('League "${league.league}" deleted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('League "${league.league}" deleted successfully')),
      );
    } catch (e) {
      log('Failed to delete league: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete league: $e')),
      );
    }
  }

  // for image pick from gallery
  Future pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      try {
        // Create a unique file name
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference =
            FirebaseStorage.instance.ref().child('images/$fileName');

        // Upload the image
        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get the image URL
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Store the image URL in Firestore
        await FirebaseFirestore.instance.collection('leagues').add({
          'image_url': imageUrl,
          // Add other league details here if needed
        });

        log('Image uploaded and URL stored successfully');
      } catch (e) {
        log('Error uploading image: $e');
      }
    } else {
      log('No image selected.');
    }
  }
}
// Update with the correct path to your model

class LeagueService {
  final CollectionReference _leaguesCollection =
      FirebaseFirestore.instance.collection('leagues');

  Stream<List<Createleague>> getLeagues() {
    return _leaguesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Createleague.fromJson(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
