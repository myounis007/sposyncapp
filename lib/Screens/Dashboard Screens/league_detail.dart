import 'package:flutter/material.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import '../../models/createleague_model.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';

class LeagueDetailScreen extends StatelessWidget {
  final Createleague league;
  final bool isFollowed;
  final bool isJoined;
  final VoidCallback onFollow;
  final VoidCallback onUnfollow;
  final VoidCallback onJoin;
  final VoidCallback onUnjoin;

  const LeagueDetailScreen({
    super.key,
    required this.league,
    required this.isFollowed,
    required this.isJoined,
    required this.onFollow,
    required this.onUnfollow,
    required this.onJoin,
    required this.onUnjoin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.apptheme,
      appBar: AppBar(
        backgroundColor: AppColors.apptheme,
        title: Text(league.league ?? 'League Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: Colors.black,
              ),
              if (league.image1 != null && league.image1!.isNotEmpty)
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    league.image1!,
                    fit: BoxFit.cover,
                  ),
                ),
              Container(
                color: Colors.white54,
                height: 400,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    MediumText(title: "League Name: ${league.league ?? 'N/A'}"),
                    const SizedBox(height: 8.0),
                    MediumText(title: "Venue: ${league.venue ?? 'N/A'}"),
                    const SizedBox(height: 8.0),
                    MediumText(title: "Player: ${league.player ?? 'N/A'}"),
                    const SizedBox(height: 8.0),
                    MediumText(title: "Role: ${league.role ?? 'N/A'}"),
                    const SizedBox(height: 8.0),
                    MediumText(title: "Duration: ${league.duration ?? 'N/A'}"),
                    const SizedBox(height: 8.0),
                    MediumText(title: "Time: ${league.time ?? 'N/A'}"),
                    const SizedBox(height: 8.0),
                    MediumText(title: "Teams: ${league.teams ?? 'N/A'}"),
                    const SizedBox(height: 8.0),
                    MediumText(title: "Umpires: ${league.umpires ?? 'N/A'}"),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              if (league.image2 != null && league.image2!.isNotEmpty)
                SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.network(
                      league.image2!,
                      fit: BoxFit.cover,
                    )),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: isFollowed ? onUnfollow : onFollow,
                    child:
                        Text(isFollowed ? 'Unfollow League' : 'Follow League'),
                  ),
                  ElevatedButton(
                    onPressed: isJoined ? onUnjoin : onJoin,
                    child: Text(isJoined ? 'Unjoin League' : 'Join League'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
