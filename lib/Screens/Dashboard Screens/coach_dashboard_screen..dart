// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, use_super_parameters
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soccer_app/Screens/Live%20Match/live_match.dart';
import 'package:soccer_app/Screens/Pakistan%20Team/pakistan_team.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/services/auth_service.dart';
import 'package:soccer_app/services/league_services.dart';
import 'package:soccer_app/Screens/Dashboard%20Screens/league_gridview.dart';
import '../../models/createleague_model.dart';
import '../Widgets/app_colors.dart';

import '../Widgets/textfield_widget.dart';

class CoachDashboardScreen extends StatefulWidget {
  const CoachDashboardScreen({Key? key}) : super(key: key);

  @override
  State<CoachDashboardScreen> createState() => _CoachDashboardScreenState();
}

class _CoachDashboardScreenState extends State<CoachDashboardScreen> {
 

  LeagueServices allleagues = LeagueServices();

  // Controllers
  final TextEditingController leagueController = TextEditingController();
  final TextEditingController venueController = TextEditingController();
  final TextEditingController playerController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController teamController = TextEditingController();
  final TextEditingController umpireController = TextEditingController();
  final TextEditingController summerController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _image1;
  File? _image2;
  String? image1Url;
  String? image2Url;
  bool isLive = false;
  bool showTeam = false;
  Future<void> _pickImage(BuildContext context, int imageNumber) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (imageNumber == 1) {
        _image1 = pickedFile != null ? File(pickedFile.path) : null;
      } else if (imageNumber == 2) {
        _image2 = pickedFile != null ? File(pickedFile.path) : null;
      }
    });
    Navigator.pop(context);
  }

  Future<String> _uploadImage(
      File image, String leagueId, int imageNumber) async {
    String fileName = 'leagues/$leagueId/image$imageNumber';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  Future<void> _createLeague() async {
    if (_formKey.currentState!.validate()) {
      try {
        Createleague newLeague = Createleague(
            league: leagueController.text,
            venue: venueController.text,
            player: playerController.text,
            role: roleController.text,
            duration: durationController.text,
            time: timeController.text,
            teams: teamController.text,
            umpires: umpireController.text,
            id: idController.text);

        DocumentReference docRef =
            await FirebaseFirestore.instance.collection('leagues').add(
                  newLeague.toJson(),
                );

        if (_image1 != null) {
          image1Url = await _uploadImage(_image1!, docRef.id, 1);
        }
        if (_image2 != null) {
          image2Url = await _uploadImage(_image2!, docRef.id, 2);
        }

        await docRef.update({
          'image1': image1Url,
          'image2': image2Url,
        });

        // Clear the form fields
        leagueController.clear();
        venueController.clear();
        playerController.clear();
        roleController.clear();
        durationController.clear();
        timeController.clear();
        teamController.clear();
        umpireController.clear();
        setState(() {
          _image1 = null;
          _image2 = null;
        });
        Get.snackbar('title', 'League created successfully!');
      } catch (e) {
        Get.snackbar('title', 'League created successfully! $e');
      }
    }
  }

  void _showImagePicker(BuildContext context, int imageNumber) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  _pickImage(context, imageNumber);
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<MyModel> data = [
    MyModel(image: 'assets/images/pak.jpg', teamName: 'Pakistan'),
    MyModel(image: 'assets/images/turkey.jpg', teamName: 'Turkey'),
    MyModel(image: 'assets/images/port.jpg', teamName: 'Portugal'),
    MyModel(image: 'assets/images/port.jpg', teamName: 'Portugal'),
    MyModel(image: 'assets/images/pak.jpg', teamName: 'Pakistan'),
    MyModel(image: 'assets/images/turkey.jpg', teamName: 'Turkey'),
  ];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.apptheme,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: InkWell(
            onTap: () {
              FirebaseService().signOut(context);
            },
            child: Text('Coach Dashboard')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFieldWidget(
                                          controller: leagueController,
                                          readOnly: false,
                                          hintText: 'League Name',
                                          validator: RequiredValidator(
                                            errorText: 'enter league',
                                          ).call,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Expanded(
                                        child: TextFieldWidget(
                                          controller: venueController,
                                          readOnly: false,
                                          hintText: 'Venue',
                                          validator: RequiredValidator(
                                            errorText: 'enter venue',
                                          ).call,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * .01),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFieldWidget(
                                          controller: playerController,
                                          readOnly: false,
                                          hintText: 'Player',
                                          validator: RequiredValidator(
                                            errorText: 'enter player',
                                          ).call,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Expanded(
                                        child: TextFieldWidget(
                                          controller: roleController,
                                          readOnly: false,
                                          hintText: 'Role',
                                          validator: RequiredValidator(
                                            errorText: 'enter role',
                                          ).call,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * .01),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFieldWidget(
                                          controller: durationController,
                                          readOnly: false,
                                          hintText: 'Duration',
                                          validator: RequiredValidator(
                                            errorText: 'enter duration',
                                          ).call,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Expanded(
                                        child: TextFieldWidget(
                                          controller: timeController,
                                          readOnly: false,
                                          hintText: 'Time Table',
                                          validator: RequiredValidator(
                                            errorText: 'enter time table',
                                          ).call,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * .01),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFieldWidget(
                                          controller: teamController,
                                          readOnly: false,
                                          hintText: 'Teams',
                                          validator: RequiredValidator(
                                            errorText: 'enter teams',
                                          ).call,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Expanded(
                                        child: TextFieldWidget(
                                          controller: umpireController,
                                          readOnly: false,
                                          hintText: 'Umpires',
                                          validator: RequiredValidator(
                                            errorText: 'enter umpires',
                                          ).call,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * .01),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            _showImagePicker(context, 1),
                                        child: _image1 == null
                                            ? Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[200],
                                                child: Icon(Icons.add_a_photo,
                                                    color: Colors.grey[800]),
                                              )
                                            : Image.file(_image1!,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            _showImagePicker(context, 2),
                                        child: _image2 == null
                                            ? Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[200],
                                                child: Icon(Icons.add_a_photo,
                                                    color: Colors.grey[800]),
                                              )
                                            : Image.file(_image2!,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                _createLeague();
                                Get.off(context);
                              },
                              child: const Text(
                                'Create League',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.red),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('cancel'))
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Create Leagues',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: height * .01),
              LargeText(title: 'Created League:'),
              SizedBox(
                height: 200,
                child: LeagueGridView(),
              ),
              // SizedBox(height: height * .02),
              LargeText(title: 'Live Matches'),
              SizedBox(height: height * .01),
              SizedBox(
                height: height * .24,
                child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LiveMatchScreen()),
                        );
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        width: width * 0.84, // Adjust the width as needed
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/pak.jpg'),
                                ),
                                title: MediumText(title: 'Pakistan'),
                                trailing: LargeText(title: '2'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MediumText(
                                      title: 'VS',
                                      color: AppColors.grey500,
                                    ),
                                    Container(
                                      height: height * .001,
                                      width: width * .22,
                                      color: AppColors.lightGrey,
                                    ),
                                    Container(
                                      height: height * .03,
                                      width: width * .13,
                                      decoration: BoxDecoration(
                                          color: AppColors.red,
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Center(
                                        child: SmallText(
                                          title: 'Live',
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: height * .001,
                                      width: width * .22,
                                      color: AppColors.lightGrey,
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/port.jpg'),
                                ),
                                title: MediumText(title: 'Portugal'),
                                trailing: LargeText(title: '1'),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              LargeText(title: 'Highlights'),
              SizedBox(height: height * .01),
              SizedBox(
                height: height * .32,
                child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: width * .03, vertical: height * .001),
                      width: width * 0.84, // Adjust the width as needed
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: SmallText(title: 'Today'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/pak.jpg',
                                      height: height * .04,
                                    ),
                                    MediumText(title: 'Pakistan'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    LargeText(title: '3-1'),
                                    SmallText(title: 'Pakistan Won'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/port.jpg',
                                      height: height * .04,
                                    ),
                                    MediumText(title: 'Portugal'),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColors.lightGrey,
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/khan.jpeg'),
                              ),
                              title: SmallText(title: 'Best Player'),
                              subtitle: MediumText(title: 'Imran Khan'),
                              trailing: SmallText(title: 'Highlights'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: height * .01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LargeText(title: 'Teams In League'),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showTeam = !showTeam;
                      });
                    },
                    child: MediumText(
                      title: showTeam ? 'Hide Teams' : 'Show Teams',
                      color: AppColors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * .02),
              showTeam
                  ? Container(
                      height: height * .3,
                      width: width,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightGrey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height,
                                width: width,
                                child: GridView.builder(
                                  itemCount: 6,
                                  shrinkWrap: true,
                                  // scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        index == 0
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PakistanTeamScreen(),
                                                ),
                                              )
                                            : null;
                                      },
                                      child: Container(
                                        height: height * .1,
                                        width: width * .2,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.lightGrey),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage:
                                                  AssetImage(data[index].image),
                                            ),
                                            SizedBox(height: height * .02),
                                            MediumText(
                                                title: data[index].teamName)
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    crossAxisCount: 3,
                                    mainAxisExtent: 100,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: height * .02),
            ],
          ),
        ),
      ),
     
    );
  }

  Widget buildImagePickerTile(BuildContext context, double height, double width,
      String title, int index, String? imageName, String? imagePath) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: height * .1,
              decoration: BoxDecoration(color: AppColors.grey500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Pick from Gallery'),
                    onTap: () async {
                      await _pickImage(context, index);
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        height: height * 0.06,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.image, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      //showImage(context, imagePath);
                    },
                    child: Text(
                      imageName ?? title,
                      style: TextStyle(
                          color: imageName != null ? Colors.blue : Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: imageName != null ? 10 : 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyModel {
  String image;
  String teamName;
  MyModel({required this.image, required this.teamName});
}
