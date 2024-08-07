import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soccer_app/models/createleague_model.dart';
import 'package:soccer_app/models/user_model.dart';

class LeagueManager {
  final UserModel userModel;
  final List<Createleague> followedLeagues = [];
  final List<Createleague> joinedLeagues = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _followedLeaguesController = StreamController<List<Createleague>>.broadcast();
  final _joinedLeaguesController = StreamController<List<Createleague>>.broadcast();

  LeagueManager(this.userModel);

  Stream<List<Createleague>> get followedLeaguesStream => _followedLeaguesController.stream;
  Stream<List<Createleague>> get joinedLeaguesStream => _joinedLeaguesController.stream;

  // Fan-specific methods
  Future<void> addFollowedLeague(Createleague league) async {
    followedLeagues.add(league);
    _followedLeaguesController.add(followedLeagues);
    await _firestore.collection('users').doc(userModel.uid).collection('followedLeagues').doc(league.id).set(league.toJson());
  }

  Future<void> removeFollowedLeague(Createleague league) async {
    followedLeagues.remove(league);
    _followedLeaguesController.add(followedLeagues);
    await _firestore.collection('users').doc(userModel.uid).collection('followedLeagues').doc(league.id).delete();
  }

  Future<void> loadFollowedLeagues() async {
    final snapshot = await _firestore.collection('users').doc(userModel.uid).collection('followedLeagues').get();
    followedLeagues.clear();
    for (var doc in snapshot.docs) {
      followedLeagues.add(Createleague.fromJson(doc.data(), doc.id));
    }
    _followedLeaguesController.add(followedLeagues);
  }

  // Player-specific methods
  Future<void> addJoinedLeague(Createleague league) async {
    joinedLeagues.add(league);
    _joinedLeaguesController.add(joinedLeagues);
    await _firestore.collection('users').doc(userModel.uid).collection('joinedLeagues').doc(league.id).set(league.toJson());
  }

  Future<void> removeJoinedLeague(Createleague league) async {
    joinedLeagues.remove(league);
    _joinedLeaguesController.add(joinedLeagues);
    await _firestore.collection('users').doc(userModel.uid).collection('joinedLeagues').doc(league.id).delete();
  }

  Future<void> loadJoinedLeagues() async {
    final snapshot = await _firestore.collection('users').doc(userModel.uid).collection('joinedLeagues').get();
    joinedLeagues.clear();
    for (var doc in snapshot.docs) {
      joinedLeagues.add(Createleague.fromJson(doc.data(), doc.id));
    }
    _joinedLeaguesController.add(joinedLeagues);
  }

  // General method to get all leagues
  Stream<List<Createleague>> getAllLeagues() {
    return _firestore.collection('leagues').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Createleague.fromJson(data, doc.id);
      }).toList();
    });
  }

  void dispose() {
    _followedLeaguesController.close();
    _joinedLeaguesController.close();
  }
}
