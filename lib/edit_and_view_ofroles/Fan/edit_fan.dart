// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:soccer_app/Screens/Widgets/round_button.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/models/user_model.dart';

import '../../services/profile_image.dart';
import '../../services/user_service.dart';
import '../../Screens/Widgets/custom_textfield.dart';

class EditFanScreen extends StatefulWidget {
  final UserModel? userModel;
  const EditFanScreen({
    super.key,
    required this.userModel,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditFanScreenState createState() => _EditFanScreenState();
}

class _EditFanScreenState extends State<EditFanScreen> {
  bool isLoading = false;
  late TextEditingController fanemailController;
  // late TextEditingController fanpasswordController;
  late TextEditingController fanteamController;
  String? imageUrlProfile;

  @override
  void initState() {
    super.initState();
    fanemailController = TextEditingController(text: widget.userModel?.email);
    // fanpasswordController =
    //     TextEditingController(text: widget.userModel.password);
    fanteamController =
        TextEditingController(text: widget.userModel?.favouriteTeam);
    imageUrlProfile = widget.userModel?.imageUrlProfile;
  }

  Future<void> pickImage() async {
    setState(() {
      isLoading = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // setState(() {
      //   imageUrlProfile = pickedFile.path; // Temporarily hold the local path
      // });
      String newImageUrl =
          await ProfileImageService.uploadFile(pickedFile.path);
      setState(
        () {
          imageUrlProfile = newImageUrl;
        },
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveChanges() async {
    UserService userService = UserService();

    UserModel updatedUser = UserModel(
      email: fanemailController.text,
      // password: fanpasswordController.text,
      favouriteTeam: fanteamController.text,
      imageUrlProfile: imageUrlProfile ?? widget.userModel?.imageUrlProfile,
    );

    await userService.updateUserData(updatedUser);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: LargeText(title: 'Edit Fan Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * .01),
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Stack(children: [
                  isLoading == true
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
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
              SizedBox(height: height * .01),
              CustomTextTField(
                  readOnly: true,
                  controller: fanemailController,
                  hintText: 'Email',
                  prefixIcon: Icons.email_outlined),
              SizedBox(height: height * .01),
              // CustomTextTField(
              //     readOnly: false,
              //     controller: fanpasswordController,
              //     hintText: 'Password',
              //     prefixIcon: Icons.lock_outline_rounded),
              // SizedBox(height: height * .01),
              CustomTextTField(
                  readOnly: false,
                  controller: fanteamController,
                  hintText: 'favouriteteam',
                  prefixIcon: Icons.supervisor_account_outlined),
              SizedBox(height: height * .03),
              SmallButton(onPressed: saveChanges, title: "Save"),
              SizedBox(height: height * .01)
            ],
          ),
        ),
      ),
    );
  }
}
