import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/createleague_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/league_services.dart';
import '../../services/leagues_manager.dart';

import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/Screens/Dashboard Screens/league_detail.dart';
import 'package:soccer_app/Screens/Widgets/round_button.dart';

import 'player_dashboard_screen.dart';

class FanDashboardScreen extends StatefulWidget {
  const FanDashboardScreen({super.key});

  @override
  State<FanDashboardScreen> createState() => _FanDashboardScreenState();
}

class _FanDashboardScreenState extends State<FanDashboardScreen> {
  final LeagueService leagueService = LeagueService();
  late LeagueManager leagueManager;
  final FirebaseService authlogout = FirebaseService();
  UserModel? userModel;
  String? userId;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        log("User is currently signed out!");
      } else {
        log("User is signed in!");
        // You can also load user data here
        loadInitialData();
      }
    });
  }

  Future<void> loadInitialData() async {
    userModel = await authlogout.getUser();
    if (userModel != null) {
      userId = userModel!.uid;
      leagueManager = LeagueManager(userModel!);
      await leagueManager.loadFollowedLeagues();
      setState(() {});
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
                      builder: (context) => const PlayerDashboardScreen(),
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
                    await authlogout.firebaseLogout(context);
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
              stream: leagueManager.getAllLeagues(),
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
                final followedLeagues = leagueManager.followedLeagues;

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
                                  isJoined: false,
                                  onFollow: () {
                                    leagueManager.addFollowedLeague(league);
                                    Fluttertoast.showToast(
                                      msg: "You followed ${league.league}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    Navigator.pop(context);
                                  },
                                  onUnfollow: () {
                                    leagueManager.removeFollowedLeague(league);
                                    Fluttertoast.showToast(
                                      msg: "You unfollowed ${league.league}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: AppColors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    Navigator.pop(context);
                                  },
                                  onJoin: () {},
                                  onUnjoin: () {},
                                ),
                              ),
                            );
                          },
                          trailing: isFollowed
                              ? IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () {
                                    leagueManager.removeFollowedLeague(league);
                                    Fluttertoast.showToast(
                                      msg: "You unfollowed ${league.league}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    setState(() {});
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  onPressed: () {
                                    leagueManager.addFollowedLeague(league);
                                    Fluttertoast.showToast(
                                      msg: "You followed ${league.league}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    setState(() {});
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
        ],
      ),
    );
  }
}
