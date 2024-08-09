import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import 'package:soccer_app/services/profile_image.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../Screens/Widgets/custom_textfield.dart';
import '../../Screens/Widgets/round_button.dart';

class EditCoachScreen extends StatefulWidget {
  final UserModel? userModel;

  const EditCoachScreen({required this.userModel, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditCoachScreenState createState() => _EditCoachScreenState();
}

class _EditCoachScreenState extends State<EditCoachScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController teamController;
  late TextEditingController experienceController;
  late TextEditingController contactController;
  String? imageUrlProfile;
  bool isLoading = false;

  // late TextEditingController passwordController;
  @override
  void initState() {
    super.initState();
    if (widget.userModel != null) {
      nameController = TextEditingController(text: widget.userModel?.name);
      emailController = TextEditingController(text: widget.userModel?.email);
      teamController = TextEditingController(text: widget.userModel?.team);
      experienceController =
          TextEditingController(text: widget.userModel?.experience.toString());
      contactController =
          TextEditingController(text: widget.userModel?.contact);
      imageUrlProfile = widget.userModel?.imageUrlProfile;
    }

    // passwordController = TextEditingController(text: widget.userModel.password);
  }

  Future<void> pickImage() async {
    setState(() {
      isLoading = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String newImageUrl =
          await ProfileImageService.uploadFile(pickedFile.path);
      setState(() {
        imageUrlProfile = newImageUrl;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveChanges() async {
    UserService userService = UserService();

    UserModel updatedUser = UserModel(
      name: nameController.text,
      email: emailController.text,
      // password: passwordController.text,
      team: teamController.text,
      experience: int.parse(experienceController.text),
      contact: contactController.text,
      imageUrlProfile: imageUrlProfile ?? widget.userModel?.imageUrlProfile,
    );

    await userService.updateUserData(updatedUser);
    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.apptheme,
      appBar: AppBar(
        backgroundColor: AppColors.apptheme,
        centerTitle: true,
        title: const Text('Update Profile Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * .06),
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Stack(children: [
                  isLoading == true
                      ? const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: widget.userModel?.imageUrlProfile !=
                                      null &&
                                  widget.userModel!.imageUrlProfile!.isNotEmpty
                              ? (imageUrlProfile!.startsWith('http')
                                  ? NetworkImage(imageUrlProfile!)
                                  : FileImage(File(imageUrlProfile!))
                                      as ImageProvider)
                              : const AssetImage(
                                      'assets/images/profileplaceholder.png')
                                  as ImageProvider,
                          // child: imageUrlProfile == null || imageUrlProfile!.isEmpty
                          //     ? const Icon(Icons.person, size: 60)
                          //     : null,
                        ),
                  const Positioned(
                      left: 80,
                      height: 200,
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.deepOrange,
                      )),
                ]),
              ),
              SizedBox(height: height * .06),
              CustomTextTField(
                readOnly: false,
                controller: nameController,
                hintText: 'Name',
                prefixIcon: Icons.person_2,
              ),
              SizedBox(height: height * .01),
              CustomTextTField(
                readOnly: true,
                controller: emailController,
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
              ),
              SizedBox(height: height * .01),
              // CustomTextTField(
              //   readOnly: false,
              //   controller: passwordController,
              //   hintText: 'Password',
              //   prefixIcon: Icons.lock_outline_rounded,
              // ),
              // SizedBox(height: height * .01),
              CustomTextTField(
                readOnly: false,
                controller: teamController,
                hintText: 'Team Name',
                prefixIcon: Icons.group,
              ),
              SizedBox(height: height * .01),
              CustomTextTField(
                readOnly: false,
                controller: experienceController,
                hintText: 'Experience',
                prefixIcon: Icons.timeline,
              ),
              SizedBox(height: height * .01),
              CustomTextTField(
                readOnly: false,
                controller: contactController,
                hintText: 'Contact Info',
                prefixIcon: Icons.phone,
              ),
              SizedBox(height: height * .03),
              RoundButton(
                title: "Save Changes",
                onPressed: saveChanges,
              ),
              SizedBox(height: height * .01),
            ],
          ),
        ),
      ),
    );
  }
}
