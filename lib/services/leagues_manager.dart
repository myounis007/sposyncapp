// import 'dart:async';
// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:soccer_app/models/createleague_model.dart';
// import 'package:soccer_app/models/user_model.dart';

// class LeagueManager {
//   final FirebaseFirestore db = FirebaseFirestore.instance;
//   final UserModel userModel;
//   List<Createleague> followedLeagues = [];
//   final List<Createleague> joinedLeagues = [];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final _followedLeaguesController =
//       StreamController<List<Createleague>>.broadcast();
//   final _joinedLeaguesController =
//       StreamController<List<Createleague>>.broadcast();

//   LeagueManager(this.userModel);

//   Stream<List<Createleague>> get followedLeaguesStream =>
//       _followedLeaguesController.stream;
//   Stream<List<Createleague>> get joinedLeaguesStream =>
//       _joinedLeaguesController.stream;

//   // Load followed and joined leagues from Firestore
//   Future<void> loadFollowedLeagues() async {
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userModel.uid)
//         .get();

//     if (userDoc.exists) {
//       // Safely cast the data to Map<String, dynamic>
//       Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

//       if (userData != null) {
//         List<dynamic> leaguesData = userData['followedLeagues'] ?? [];
//         followedLeagues = leaguesData
//             .map((json) => Createleague.fromJson(json, json['id']))
//             .toList();
//       } else {
//         log("User document data is null.");
//       }
//     } else {
//       log("User document does not exist.");
//     }
//   }

//   Future<void> updateFollowedLeaguesInFirestore() async {
//     DocumentReference userDocRef =
//         FirebaseFirestore.instance.collection('users').doc(userModel.uid);

//     // Check if the document exists
//     DocumentSnapshot userDoc = await userDocRef.get();

//     if (userDoc.exists) {
//       // Update the followedLeagues field
//       await userDocRef.update({
//         'followedLeagues':
//             followedLeagues.map((league) => league.toJson()).toList(),
//       });
//     } else {
//       log("User document does not exist, creating new document.");
//       // Create a new document with an empty followedLeagues field
//       await userDocRef.set({
//         'followedLeagues':
//             followedLeagues.map((league) => league.toJson()).toList(),
//       });
//     }
//   }
//   // Fan-specific methods

//   Future<void> addFollowedLeague(String userId, String leagueId) async {
//     try {
//       // Check if the user document exists
//       DocumentReference userRef = db.collection('users').doc(userId);
//       DocumentSnapshot userDoc = await userRef.get();

//       if (userDoc.exists) {
//         // Update the followedLeagues array for the user
//         await userRef.update({
//           'followedLeagues': FieldValue.arrayUnion([leagueId])
//         });
//       } else {
//         // Handle the case where the user document does not exist
//         log('User document does not exist for user ID: $userId');
//       }
//     } catch (e) {
//       // Log any errors
//       log('Error adding followed league: $e');
//       rethrow; // Rethrow the error to handle it higher up if needed
//     }
//   }

//   Future<void> removeFollowedLeague(Createleague league) async {
//     followedLeagues.removeWhere((l) => l.id == league.id);
//     _followedLeaguesController.add(followedLeagues);

//     // Update the user's followed leagues in Firestore
//     await _firestore.collection('users').doc(userModel.uid).update({
//       'followedLeagues': FieldValue.arrayRemove([league.id]),
//     });
//   }

//   // Player-specific methods
//   Future<void> addJoinedLeague(Createleague league) async {
//     joinedLeagues.add(league);
//     _joinedLeaguesController.add(joinedLeagues);

//     // Update the user's joined leagues in Firestore
//     await _firestore.collection('users').doc(userModel.uid).update({
//       'joinedLeagues': FieldValue.arrayUnion([league.id]),
//     });
//   }

//   Future<void> removeJoinedLeague(Createleague league) async {
//     joinedLeagues.removeWhere((l) => l.id == league.id);
//     _joinedLeaguesController.add(joinedLeagues);

//     // Update the user's joined leagues in Firestore
//     await _firestore.collection('users').doc(userModel.uid).update({
//       'joinedLeagues': FieldValue.arrayRemove([league.id]),
//     });
//   }

//   // General method to get all leagues
//   Stream<List<Createleague>> getAllLeagues() {
//     return _firestore.collection('leagues').snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final data = doc.data();
//         return Createleague.fromJson(data, doc.id);
//       }).toList();
//     });
//   }

//   // New method to get a stream of followed leagues
//   Stream<List<Createleague>> getFollowedLeaguesStream() async* {
//     final userDoc = _firestore.collection('users').doc(userModel.uid);

//     // Listen to changes in the user's followed leagues
//     yield* userDoc.snapshots().asyncMap((docSnapshot) async {
//       if (docSnapshot.exists) {
//         List<dynamic> leagueIds = docSnapshot.data()?['followedLeagues'] ?? [];
//         List<Createleague> leagues = [];
//         for (var leagueId in leagueIds) {
//           DocumentSnapshot leagueDoc =
//               await _firestore.collection('leagues').doc(leagueId).get();
//           if (leagueDoc.exists) {
//             leagues.add(Createleague.fromJson(
//                 leagueDoc.data() as Map<String, dynamic>, leagueDoc.id));
//           }
//         }
//         return leagues;
//       } else {
//         return [];
//       }
//     });
//   }

//   void dispose() {
//     _followedLeaguesController.close();
//     _joinedLeaguesController.close();
//   }
// }
