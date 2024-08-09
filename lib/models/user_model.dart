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
  List<Map<String, dynamic>>? followedLeagues;
  List<Map<String, dynamic>>? joinedLeagues;

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

  // Convert a UserModel into a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'name': name,
      'email': email,
      'password': password,
      'contact': contact,
      'experience': experience,
      'position': position,
      'favourite_team': favouriteTeam,
      'team': team,
      'imageUrlProfile': imageUrlProfile,
      'uid': uid,
      'followedLeagues': followedLeagues,
      'joinedLeagues': joinedLeagues,
    };
  }

  // Create a UserModel from a Map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      role: json['role'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      contact: json['contact'],
      experience: json['experience'],
      position: json['position'],
      favouriteTeam: json['favourite_team'],
      team: json['team'],
      imageUrlProfile: json['imageUrlProfile'],
      uid: json['uid'],
      followedLeagues:
          List<Map<String, dynamic>>.from(json['followedLeagues'] ?? []),
      joinedLeagues:
          List<Map<String, dynamic>>.from(json['joinedLeagues'] ?? []),
    );
  }

  // Convert a UserModel into a Map for Firestore update
  Map<String, dynamic> toFirestore() {
    return {
      'role': role,
      'name': name,
      'email': email,
      'password': password,
      'contact': contact,
      'experience': experience,
      'position': position,
      'favourite_team': favouriteTeam,
      'team': team,
      'imageUrlProfile': imageUrlProfile,
      'uid': uid,
      'followedLeagues': followedLeagues,
      'joinedLeagues': joinedLeagues,
    };
  }

  // Create a UserModel from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      role: data['role'],
      name: data['name'],
      email: data['email'],
      password: data['password'],
      contact: data['contact'],
      experience: data['experience'],
      position: data['position'],
      favouriteTeam: data['favourite_team'],
      team: data['team'],
      imageUrlProfile: data['imageUrlProfile'],
      uid: data['uid'],
      followedLeagues:
          List<Map<String, dynamic>>.from(data['followedLeagues'] ?? []),
      joinedLeagues:
          List<Map<String, dynamic>>.from(data['joinedLeagues'] ?? []),
    );
  }
}
