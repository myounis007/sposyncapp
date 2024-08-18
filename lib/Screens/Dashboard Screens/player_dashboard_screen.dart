import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soccer_app/Screens/Widgets/round_button.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/models/user_model.dart';
import 'package:soccer_app/services/auth_service.dart';
import '../../edit_and_view_ofroles/Player/player_screen.dart';
import '../../models/createleague_model.dart';
import '../../services/league_services.dart';
import '../Widgets/app_colors.dart';
import 'league_detail.dart';

class PlayerDashboardScreen extends StatefulWidget {
  final UserModel? userModel;

  const PlayerDashboardScreen({
    super.key,
    this.userModel,
  });

  @override
  State<PlayerDashboardScreen> createState() => _PlayerDashboardScreenState();
}

class _PlayerDashboardScreenState extends State<PlayerDashboardScreen> {
  final LeagueService leagueService = LeagueService();
  final FirebaseService firebaseService = FirebaseService();
  List<Createleague> joinedLeagues = [];
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    loadInitialData();
    fetchJoinedLeagues();
  }

  Future<void> loadInitialData() async {
    userModel = await firebaseService.getUser();
    if (userModel != null) {
      setState(() {});
    }
  }

  Future<void> fetchJoinedLeagues() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Check if a user is logged in
      if (user == null) {
        log("No Firebase user is currently logged in.");
        return;
      }

      String userId = user.uid;

      // Get the user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if the document exists and contains the 'joinedLeagues' field
      if (userDoc.exists && userDoc.data()!.containsKey('joinedLeagues')) {
        List<dynamic> leaguesData = userDoc.data()!['joinedLeagues'];

        // Convert the list of maps to a list of Createleague objects
        List<Createleague> leagues =
            leaguesData.map((data) => Createleague.fromJson(data)).toList();

        setState(() {
          joinedLeagues = leagues;
        });
        log(" Hi Joined Leages ==> $joinedLeagues");
      }
    } catch (e) {
      log("Failed to fetch joined leagues: $e");
    }
  }

  void _addJoinedLeague(Createleague league) {
    setState(() {
      joinedLeagues.add(league);
    });
    _updateJoinedLeaguesInFirestore();
  }

  Future<void> _updateJoinedLeaguesInFirestore() async {
    try {
      // Assuming `userId` is the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Convert `joinedLeagues` to a list of maps for Firestore
      List<Map<String, dynamic>> leaguesData =
          joinedLeagues.map((league) => league.toJson()).toList();

      // Update the `joinedLeagues` field in the user's document
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'joinedLeagues': FieldValue.arrayUnion(leaguesData),
      });

      log("Joined leagues updated successfully");
    } catch (e) {
      log("Failed to update joined leagues: $e");
    }
  }

  void _removeJoinedLeague(Createleague league) {
    for (var i = 0; i < joinedLeagues.length; i++) {
      log("hi my list ==> ${league.id} and ${joinedLeagues[i].id}");
      if (joinedLeagues[i].id == league.id) {
        setState(() {
          joinedLeagues.remove(league);
        });
      }
    }

    // setState(() {
    //   joinedLeagues
    //       .removeWhere((existingLeague) => existingLeague.id == league.id);
    // });
    _updateRemovedLeagueInFirestore(league);
  }

  Future<void> _updateRemovedLeagueInFirestore(Createleague league) async {
    try {
      // Assuming `userId` is the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Convert the `league` to a map
      Map<String, dynamic> leagueData = league.toJson();

      // Remove the league from the `joinedLeagues` field in Firestore

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'joinedLeagues': FieldValue.arrayRemove([leagueData]),
      });
      log("League removed successfully from joined leagues");
    } catch (e) {
      log("Failed to remove league: $e");
    }
  }

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
                child: Center(child: Text('${userModel?.name}')),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlayerScreen(),
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
                  title: 'Logout',
                  onPressed: () async {
                    await firebaseService.signOut(context);
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
        backgroundColor: AppColors.apptheme,
        centerTitle: true,
        title: LargeText(title: 'Player Dashboard'),
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
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No leagues available'));
                }

                final leagues = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.black, width: 2),
                    ),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: leagues.length,
                      itemBuilder: (context, index) {
                        final league = leagues[index];
                        final isFollowed =
                            joinedLeagues.any((l) => l.id == league.id);
                        return Card(
                          child: ListTile(
                            leading: league.image1 != null &&
                                    league.image1!.isNotEmpty
                                ? Image.network(league.image1!)
                                : const Icon(Icons.image_not_supported),
                            title: Text(league.league ?? 'Unnamed League'),
                            subtitle:
                                Text(league.venue ?? 'No venue available'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LeagueDetailScreen(
                                    league: league,
                                    isFollowed: isFollowed,
                                    onFollow: () {
                                      _addJoinedLeague(league);
                                      Fluttertoast.showToast(
                                          msg: "You joined ${league.league}",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Navigator.pop(context);
                                    },
                                    fromAllLeagues: true,
                                    onUnfollow: () {
                                      _removeJoinedLeague(league);
                                      Fluttertoast.showToast(
                                          msg: "You unjoined ${league.league}",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: AppColors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
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
                      'Joined Leagues',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: joinedLeagues.isEmpty
                      ? const Center(child: Text('No Joined leagues'))
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: joinedLeagues.length,
                            itemBuilder: (context, index) {
                              Createleague league = joinedLeagues[index];
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
                                      _removeJoinedLeague(league);
                                      Fluttertoast.showToast(
                                          msg: "You UnJoined ${league.league}",
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
                                            _removeJoinedLeague(league);
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You UnJoined ${league.league}",
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
