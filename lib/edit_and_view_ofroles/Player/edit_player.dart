// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:soccer_app/Screens/Widgets/round_button.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/models/user_model.dart';

import '../../Screens/Widgets/custom_textfield.dart';
import '../../services/profile_image.dart';
import '../../services/user_service.dart';

class EditPlayerScreen extends StatefulWidget {
  final UserModel? userModel;
  const EditPlayerScreen({
    super.key,
    this.userModel,
  });

  @override
  _EditPlayerScreenState createState() => _EditPlayerScreenState();
}

class _EditPlayerScreenState extends State<EditPlayerScreen> {
  bool isLoading = false;
  late TextEditingController plyernameController;
  late TextEditingController playeremailController;
  // late TextEditingController playerpasswordController;
  late TextEditingController playerpositionController;
  late TextEditingController playercontactController;
  String? imageUrlProfile;

  @override
  void initState() {
    super.initState();
    plyernameController = TextEditingController(text: widget.userModel?.name);
    playeremailController =
        TextEditingController(text: widget.userModel?.email);
    // playerpasswordController =
    //     TextEditingController(text: widget.userModel?.password);
    playerpositionController =
        TextEditingController(text: widget.userModel?.position);
    playercontactController =
        TextEditingController(text: widget.userModel?.contact);
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
      name: plyernameController.text,
      email: playeremailController.text,
      // password: playerpasswordController.text,
      position: playerpositionController.text,
      contact: playercontactController.text,
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
        title: LargeText(title: 'Edit Player Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
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
              SizedBox(
                height: 15,
              ),
              CustomTextTField(
                  readOnly: false,
                  controller: plyernameController,
                  hintText: 'Name',
                  prefixIcon: Icons.person_2),
              SizedBox(height: height * .01),
              CustomTextTField(
                  readOnly: true,
                  controller: playeremailController,
                  hintText: 'Email',
                  prefixIcon: Icons.email_outlined),
              SizedBox(height: height * .01),
              // CustomTextTField(
              //     readOnly: false,
              //     controller: playerpasswordController,
              //     hintText: 'Password',
              //     prefixIcon: Icons.lock_outline_rounded),
              // SizedBox(height: height * .01),
              CustomTextTField(
                  readOnly: false,
                  controller: playerpositionController,
                  hintText: 'Position',
                  prefixIcon: Icons.sports_soccer),
              SizedBox(height: height * .01),
              CustomTextTField(
                  readOnly: false,
                  controller: playercontactController,
                  hintText: 'Contact',
                  prefixIcon: Icons.contact_page_outlined),
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
