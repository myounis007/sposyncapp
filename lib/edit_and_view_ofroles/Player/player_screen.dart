// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'package:soccer_app/Screens/Widgets/round_button.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/edit_and_view_ofroles/Player/edit_player.dart';

import '../../Screens/Widgets/custom_textfield.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  UserModel? userModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    UserService userService = UserService();
    UserModel? data = await userService.fetchUserData();
    setState(() {
      userModel = data;
      isLoading = false;
    });
  }

  Future<void> navigateToEditplayerScreen() async {
    if (userModel == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPlayerScreen(userModel: userModel!)),
    );

    if (result == true) {
      fetchData(); // Reload the data when coming back from the edit screen
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: LargeText(title: 'Player Profile'),
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: userModel?.imageUrlProfile != null
                          ? NetworkImage(userModel!.imageUrlProfile!)
                              as ImageProvider
                          : const AssetImage(
                                  'assets/images/profileplaceholder.png')
                              as ImageProvider,
                    ),
                    SizedBox(height: height * .06),
                    CustomTextTField(
                        readOnly: true,
                        hintText: userModel?.name,
                        prefixIcon: Icons.person_2),
                    SizedBox(height: height * .01),
                    CustomTextTField(
                        readOnly: true,
                        hintText: userModel?.email,
                        prefixIcon: Icons.email_outlined),
                    SizedBox(height: height * .01),
                    // CustomTextTField(
                    //     readOnly: true,
                    //     hintText: userModel!.password,
                    //     prefixIcon: Icons.lock_outline_rounded),
                    // SizedBox(height: height * .01),
                    CustomTextTField(
                        readOnly: true,
                        hintText: userModel?.position,
                        prefixIcon: Icons.sports_soccer),
                    SizedBox(height: height * .01),
                    CustomTextTField(
                        readOnly: true,
                        hintText: userModel?.contact,
                        prefixIcon: Icons.contact_page_outlined),
                    SizedBox(
                      height: height * .03,
                    ),
                    SmallButton(
                        onPressed: navigateToEditplayerScreen,
                        title: "Edit Profile"),
                    SizedBox(height: height * .01)
                  ],
                ),
              ),
            ),
    );
  }
}
