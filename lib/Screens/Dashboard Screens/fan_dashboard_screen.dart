// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:soccer_app/Screens/Dashboard%20Screens/league_detail.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import 'package:soccer_app/Screens/Widgets/round_button.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/edit_and_view_ofroles/Fan/fan_screen.dart';
import 'package:soccer_app/services/auth_service.dart';

import '../../models/createleague_model.dart';
import '../../models/user_model.dart';
import '../../services/league_services.dart';

class FanDashboardScreen extends StatefulWidget {
  final UserModel? userModel;
  const FanDashboardScreen({
    super.key,
    this.userModel,
  });

  @override
  State<FanDashboardScreen> createState() => _FanDashboardScreenState();
}

class _FanDashboardScreenState extends State<FanDashboardScreen> {
  final LeagueService leagueService = LeagueService();
  final FirebaseService firebaseService = FirebaseService();
  List<Createleague> followedLeagues = [];
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    loadInitialData();
    fetchfolloedLeagues();
  }

  Future<void> loadInitialData() async {
    userModel = await firebaseService.getUser();
    if (userModel != null) {
      setState(() {});
    }
  }

  Future fetchfolloedLeagues() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log("No Firebase user is currently logged in.");
        return;
      }

      String userId = user.uid;

      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if the document exists and contains the 'followedLeagues' field
      if (userDoc.exists && userDoc.data()!.containsKey('followedLeagues')) {
        List<dynamic> leaguesData = userDoc.data()!['followedLeagues'];

        // Convert the list of maps to a list of Createleague objects
        List<Createleague> leagues =
            leaguesData.map((data) => Createleague.fromJson(data)).toList();

        setState(() {
          followedLeagues = leagues;
        });
      }
    } catch (e) {
      log("Failed to fetch followed leagues: $e");
    }
    return [];
  }

  void _addFollowedLeagues(Createleague league) {
    setState(() {
      followedLeagues.add(league);
    });
    _updatefollowedLeaguesInFirestore();
  }

  Future<void> _updatefollowedLeaguesInFirestore() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Convert the `followedLeagues` to a list of maps
      List<Map<String, dynamic>> leaguesData =
          followedLeagues.map((league) => league.toJson()).toList();
      log("MyData ==> $leaguesData");
      // Update the entire `followedLeagues` field in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update(
        {
          'followedLeagues': leaguesData,
        },
      );

      log("Followed leagues updated successfully");
    } catch (e) {
      log("Failed to update followed leagues: $e");
    }
  }

  void _removeFollowedLeague(Createleague league) {
    for (var i = 0; i < followedLeagues.length; i++) {
      log("MyLeaguesRemoved ==> ${followedLeagues[i].id} and ${league.id}");
      if (followedLeagues[i].id == league.id) {
        followedLeagues.remove(league);
        updateRemovedLeagueInFirestore(league);
      }
    }
    setState(() {});
  }

  Future updateRemovedLeagueInFirestore(Createleague league) async {
    try {
      // Assuming `userId` is the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Convert the `league` to a map
      Map<String, dynamic> leagueData = league.toJson();
      // Remove the league from the `followedLeagues` field in Firestore
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'followedLeagues': FieldValue.arrayRemove([leagueData]),
      });
      setState(() {});
      log("League removed successfully from followed leagues");
    } catch (e) {
      log("Failed to remove league: $e");
    }
  }

  FirebaseService authlogout = FirebaseService();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    if (userModel == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.apptheme,
      drawer: Drawer(
        child: Container(
          height: height,
          width: double.infinity,
          decoration: const BoxDecoration(color: AppColors.white),
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.deepOrange),
                child: Center(
                  child: Text('${userModel?.favouriteTeam}'),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FanScreen(),
                    ),
                  );
                },
                leading: const Icon(Icons.dashboard_sharp),
                title: MediumText(title: 'Profile'),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundButton(
                  title: 'logout',
                  onPressed: () async {
                    authlogout.signOut(context);
                  },
                ),
              ),
              SmallText(
                  fontSize: 12, title: 'Terms and condition | Privacy Policy'),
              SizedBox(height: height * .02)
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        centerTitle: true,
        title: LargeText(title: 'Fan Dashboard'),
      ),
      body: Column(
        children: [
          const Divider(
            indent: 13,
            endIndent: 30,
            color: Colors.black,
          ),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'All Leagues',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: StreamBuilder<List<Createleague>>(
              stream: leagueService.getLeagues(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No leagues available'));
                }

                final leagues = snapshot.data!;

                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: leagues.length,
                      itemBuilder: (context, index) {
                        final league = leagues[index];
                        final isFollowed =
                            followedLeagues.any((l) => l.id == league.id);
                        return Card(
                            child: ListTile(
                          leading:
                              league.image1 != null && league.image1!.isNotEmpty
                                  ? Image.network(league.image1!)
                                  : const Icon(Icons.image_not_supported),
                          title: Text(
                              '${index + 1}: ${league.league ?? 'Unnamed League'}'),
                          subtitle: Text(league.venue ?? 'No venue available'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeagueDetailScreen(
                                  league: league,
                                  isFollowed: isFollowed,
                                  onFollow: () {
                                    _addFollowedLeagues(league);
                                    Fluttertoast.showToast(
                                        msg: "You followed ${league.league}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.pop(context);
                                  },
                                  onUnfollow: () {
                                    _removeFollowedLeague(league);
                                    Fluttertoast.showToast(
                                        msg: "You Unfollowed ${league.league}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: AppColors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.pop(context);
                                  },
                                  fromAllLeagues: true,
                                ),
                              ),
                            );
                          },
                        ));
                      },
                    ));
              },
            ),
          ),
          const Divider(
            indent: 13,
            endIndent: 30,
            color: Colors.black,
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Followed Leagues',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: followedLeagues.isEmpty
                      ? const Center(child: Text('No followed leagues'))
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: followedLeagues.length,
                            itemBuilder: (context, index) {
                              final league = followedLeagues[index];
                              log("MyFollowed Leagues ${league.id}");
                              return Card(
                                child: ListTile(
                                  leading: league.image1 != null &&
                                          league.image1!.isNotEmpty
                                      ? Image.network(league.image1!)
                                      : const Icon(Icons.image_not_supported),
                                  title: Text(
                                      '${index + 1}: ${league.league ?? 'Unnamed League'}'),
                                  subtitle: Text(
                                      league.venue ?? 'No venue available'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _removeFollowedLeague(league);
                                      Fluttertoast.showToast(
                                          msg:
                                              "You Unfollowed ${league.league}",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: AppColors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LeagueDetailScreen(
                                          league: league,
                                          isFollowed: true,
                                          fromFollowedleagues: true,
                                          onUnfollow: () {
                                            _removeFollowedLeague(league);
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You Unfollowed ${league.league}",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.TOP,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    AppColors.black,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            Navigator.pop(context);
                                          },
                                          onFollow: () {},
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
