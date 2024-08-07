// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:soccer_app/edit_and_view_ofroles/Fan/edit_fan.dart';
import 'package:soccer_app/Screens/Widgets/round_button.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../Screens/Widgets/custom_textfield.dart';

class FanScreen extends StatefulWidget {
  const FanScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FanScreenState createState() => _FanScreenState();
}

class _FanScreenState extends State<FanScreen> {
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

  Future<void> navigateToEditfanScreen() async {
    if (userModel == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditFanScreen(userModel: userModel!)),
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
        title: LargeText(title: 'Fan Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: userModel?.imageUrlProfile != null
                    ? NetworkImage(userModel!.imageUrlProfile!) as ImageProvider
                    : const AssetImage('assets/images/profileplaceholder.png')
                        as ImageProvider,
                // child: userModel!.imageUrlProfile == null
                //     ? const Icon(Icons.person, size: 60)
                //     : null,
              ),
              SizedBox(height: height * .06),
              SizedBox(height: height * .01),
              CustomTextTField(
                  readOnly: true,
                  hintText: userModel?.email,
                  prefixIcon: Icons.email_outlined),
              SizedBox(height: height * .01),
              // CustomTextTField(
              //     readOnly: true,
              //     hintText: userModel?.password,
              //     prefixIcon: Icons.lock_outline_rounded),
              // SizedBox(height: height * .01),

              CustomTextTField(
                  readOnly: true,
                  hintText: userModel?.favouriteTeam ?? 'no favourite team',
                  prefixIcon: Icons.supervisor_account_outlined),
              SizedBox(
                height: height * .03,
              ),
              SmallButton(
                  onPressed: navigateToEditfanScreen, title: "Edit Profile"),
              SizedBox(height: height * .01)
            ],
          ),
        ),
      ),
    );
  }
}
