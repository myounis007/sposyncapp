// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:soccer_app/edit_and_view_ofroles/Player/player_detail_screen.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';

class PakistanTeamScreen extends StatefulWidget {
  const PakistanTeamScreen({super.key});

  @override
  State<PakistanTeamScreen> createState() => _PakistanTeamScreenState();
}

class _PakistanTeamScreenState extends State<PakistanTeamScreen> {
  List<PlayerModel> data = [
    PlayerModel(
        age: 28,
        role: 'Player',
        image: 'assets/images/ronaldo.png',
        name: "Ronaldo"),
    PlayerModel(
        age: 28,
        role: 'Keeper',
        image: 'assets/images/messi.jpg',
        name: "Messi"),
    PlayerModel(
        age: 28,
        role: 'Player',
        image: 'assets/images/ronaldo.png',
        name: "Ronaldo"),
    PlayerModel(
        age: 28,
        role: 'Keeper',
        image: 'assets/images/messi.jpg',
        name: "Messi"),
    PlayerModel(
        age: 28,
        role: 'Player',
        image: 'assets/images/ronaldo.png',
        name: "Ronaldo"),
    PlayerModel(
        age: 28,
        role: 'Keeper',
        image: 'assets/images/messi.jpg',
        name: "Messi"),
    PlayerModel(
        age: 28,
        role: 'Player',
        image: 'assets/images/ronaldo.png',
        name: "Ronaldo"),
    PlayerModel(
        age: 28,
        role: 'Keeper',
        image: 'assets/images/messi.jpg',
        name: "Messi"),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.apptheme,
      appBar: AppBar(
        backgroundColor: AppColors.apptheme,
        title: LargeText(title: 'Pakistan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            mainAxisExtent: height * .3,
            childAspectRatio: 0.75, // Adjust as needed to control item size
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayerDetailScreen(
                            image: data[index].image,
                            age: data[index].age,
                            name: data[index].name,
                            role: data[index].role)));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: height * .1,
                  width: width * .3,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(data[index].image),
                        ),
                        SizedBox(height: 4),
                        MediumText(title: data[index].name),
                        MediumText(title: '${data[index].age}'),
                        MediumText(title: 'Role: ${data[index].role}'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlayerModel {
  String image;
  String name;
  int age;
  String role;
  PlayerModel(
      {required this.age,
      required this.role,
      required this.image,
      required this.name});
}
