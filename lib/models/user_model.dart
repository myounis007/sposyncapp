// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? role;
  String? name;
  String? email;
  String? password;
  String? contact;
  int? experience;
  String? position;
  String? favouriteTeam;
  String? team;
  String? imageUrlProfile;
  String? uid;
  List<String>? followedLeagues; // List of followed league IDs for fans
  List<String>? joinedLeagues;   // List of joined league IDs for players

  UserModel({
    this.role,
    this.name,
    this.email,
    this.password,
    this.contact,
    this.experience,
    this.position,
    this.favouriteTeam,
    this.team,
    this.imageUrlProfile,
    this.uid,
    this.followedLeagues,
    this.joinedLeagues,
  });

  // Convert a UserModel into a Map
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'name': name,
      'email': email,
      'team': team,
      'password': password,
      'contact': contact,
      'experience': experience,
      'position': position,
      'favourite_team': favouriteTeam,
      'imageUrlProfile': imageUrlProfile,
      'uid': uid,
      'followedLeagues': followedLeagues, // Add followed leagues
      'joinedLeagues': joinedLeagues,     // Add joined leagues
    };
  }

  // Create a UserModel from a Map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      role: json['role'],
      name: json['name'],
      email: json['email'],
      contact: json['contact'],
      experience: json['experience'],
      position: json['position'],
      favouriteTeam: json['favourite_team'],
      team: json['team'],
      imageUrlProfile: json['imageUrlProfile'],
      uid: json['uid'],
      followedLeagues: List<String>.from(json['followedLeagues'] ?? []), // Initialize followed leagues
      joinedLeagues: List<String>.from(json['joinedLeagues'] ?? []),     // Initialize joined leagues
    );
  }

  // Create a UserModel from a Firestore DocumentSnapshot
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }
}
