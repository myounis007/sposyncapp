// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({super.key});

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          title: LargeText(title: 'Live Matches'),
        ),
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 40),
                SizedBox(
                  height: height,
                  child: GridView.builder(
                    itemCount: 3,
                    // scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1),
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        width: width * 0.86, // Adjust the width as needed
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
                              Align(
                                alignment: Alignment.topLeft,
                                child: SmallText(title: 'Live'),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                      SmallText(title: 'Half-Time'),
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
                              SizedBox(height: height * .02),
                              Divider(color: AppColors.lightGrey),
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
              ],
            ),
          ),
        ));
  }
}
