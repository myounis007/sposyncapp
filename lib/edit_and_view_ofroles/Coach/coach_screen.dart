import 'package:flutter/material.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import 'package:soccer_app/services/auth_service.dart';
import '../../Screens/Widgets/round_button.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../Screens/Widgets/custom_textfield.dart';
import 'edit_coach.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  _CoachScreenState createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  UserModel? userModel;
  Future<void> fetchData() async {
    UserService userService = UserService();
    final data = await userService.fetchUserData();
    setState(() {
      userModel = data;
      isLoading = false;
    });
  }

  Future<void> navigateToEditCoachScreen() async {
    if (userModel == null) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditCoachScreen(userModel: userModel!)),
    );
    if (result == true) {
      fetchData(); // Reload the data when coming back from the edit screen
    }
  }

  FirebaseService authlogout = FirebaseService();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (userModel == null) {
      return const Scaffold(
        body: Center(
          child: Text("No data found"),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: AppColors.apptheme,
        endDrawer: Drawer(
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.apptheme),
            child: Column(
              children: [
                SizedBox(height: height * .04),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: userModel?.imageUrlProfile != null
                      ? NetworkImage(userModel!.imageUrlProfile!)
                          as ImageProvider
                      : const AssetImage('assets/images/profileplaceholder.png')
                          as ImageProvider,
                  // child: userModel!.imageUrlProfile == null
                  //     ? const Icon(Icons.person, size: 60)
                  //     : null,
                ),
                const Divider(
                  color: Colors.black,
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.dashboard_sharp),
                  title: MediumText(title: 'Go to Dashboard'),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundButton(
                    title: 'logout',
                    onPressed: () async {
                      authlogout.firebaseLogout(context);
                    },
                  ),
                ),
                SmallText(
                  fontSize: 12,
                  title: 'Terms and condition | Privacy Policy',
                ),
                SizedBox(height: height * .02),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: AppColors.apptheme,
          centerTitle: true,
          title: LargeText(title: 'Coach Profile'),
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
                      ? NetworkImage(userModel!.imageUrlProfile!)
                          as ImageProvider
                      : const AssetImage('assets/images/profileplaceholder.png')
                          as ImageProvider,
                ),
                SizedBox(height: height * .06),
                CustomTextTField(
                  readOnly: true,
                  hintText: userModel!.name,
                  prefixIcon: Icons.person_2,
                ),
                SizedBox(height: height * .01),
                CustomTextTField(
                  readOnly: true,
                  hintText: userModel!.email,
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(height: height * .01),
                // CustomTextTField(
                //   readOnly: true,
                //   hintText: userModel!.password,
                //   prefixIcon: Icons.lock_outline_rounded,
                // ),
                // SizedBox(height: height * .01),
                CustomTextTField(
                  readOnly: true,
                  hintText: userModel!.team,
                  prefixIcon: Icons.group,
                ),
                SizedBox(height: height * .01),
                CustomTextTField(
                  readOnly: true,
                  hintText: userModel!.experience.toString(),
                  prefixIcon: Icons.timeline,
                ),
                SizedBox(height: height * .01),
                CustomTextTField(
                  readOnly: true,
                  hintText: userModel!.contact,
                  prefixIcon: Icons.phone,
                ),
                SizedBox(height: height * .03),
                SmallButton(
                  onPressed: navigateToEditCoachScreen,
                  title: "Edit Profile",
                ),
                SizedBox(height: height * .01),
              ],
            ),
          ),
        ),
      );
    }
  }
}
