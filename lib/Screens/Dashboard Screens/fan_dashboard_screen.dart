import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:soccer_app/Screens/Dashboard%20Screens/league_detail.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/services/auth_service.dart';
import 'package:soccer_app/edit_and_view_ofroles/Fan/fan_screen.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import 'package:soccer_app/Screens/Widgets/round_button.dart';
import '../../models/createleague_model.dart';
import '../../models/user_model.dart';
import '../../services/league_services.dart';

class FanDashboardScreen extends StatefulWidget {
  const FanDashboardScreen({super.key});

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

    _loadUserData();
    _loadFollowedLeagues();
  }

  Future<void> _loadUserData() async {
    userModel = await firebaseService.getUser();
    if (userModel != null) {
      // Load followed leagues when user data is available
      _loadFollowedLeagues();
    }
  }

  Future<void> _loadFollowedLeagues() async {
    if (userModel != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.uid)
          .get();

      if (userDoc.exists) {
        // Safely cast the data to Map<String, dynamic>
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          List<dynamic> leaguesData = userData['followedLeagues'] ?? [];
          followedLeagues = leaguesData
              .map((json) => Createleague.fromJson(json, json['id']))
              .toList();
          setState(() {});
        } else {
          log("User document data is null.");
        }
      } else {
        log("User document does not exist.");
      }
    }
  }

  Future<void> _updateFollowedLeaguesInFirestore() async {
    if (userModel != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userModel!.uid);

      // Check if the document exists
      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        // Update the followedLeagues field in the existing document
        await userDocRef.update({
          'followedLeagues':
              followedLeagues.map((league) => league.toJson()).toList(),
        });
      } else {
        log("User document does not exist, creating new document.");
        // Create a new document with followedLeagues if none exists
        await userDocRef.set({
          'followedLeagues':
              followedLeagues.map((league) => league.toJson()).toList(),
        });
      }
    }
  }

  void _addFollowedLeague(Createleague league) async {
    setState(() {
      followedLeagues.add(league);
    });

    if (userModel != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userModel!.uid);

      await userDocRef.update({
        'followedLeagues': FieldValue.arrayUnion([league.toJson()]),
      }).catchError((error) async {
        // If the document doesn't exist, create it and add the league
        await userDocRef.set({
          'followedLeagues': [league.toJson()],
        });
      });
    }
  }

  void _removeFollowedLeague(Createleague league) async {
    setState(() {
      followedLeagues.removeWhere((l) => l.id == league.id);
    });

    if (userModel != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userModel!.uid);

      await userDocRef.update({
        'followedLeagues': FieldValue.arrayRemove([league.toJson()]),
      }).catchError((error) {
        // Handle error (e.g., log it or show a message)
        log('$error');
      });
    }
  }

  FirebaseService authlogout = FirebaseService();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

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
                          builder: (context) => const FanScreen()));
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
                                    _addFollowedLeague(league);
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
