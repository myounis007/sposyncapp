// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';

class PlayerDetailScreen extends StatelessWidget {
  final String image;
  final String name;
  final int age;
  final String role;
  const PlayerDetailScreen(
      {super.key,
      required this.age,
      required this.name,
      required this.role,
      required this.image});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.apptheme,
      body: Stack(
        children: [
          Container(
              height: height * .6,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LargeText(
                    fontSize: height * .1,
                    title: name,
                    color: AppColors.white,
                  )
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: height * .45,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.deepPurple[300],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 16, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LargeText(
                        title: 'Professional Details:',
                        color: AppColors.white,
                      ),
                      SizedBox(height: height * .01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: height * .13,
                            width: width * .3,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: height * .02),
                              child: Column(
                                children: [
                                  LargeText(
                                    title: "Matches",
                                    // color: AppColors.white,
                                  ),
                                  LargeText(
                                    title: "290",
                                    // color: AppColors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: height * .13,
                            width: width * .3,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * .02,
                                  vertical: height * .02),
                              child: Column(
                                children: [
                                  LargeText(
                                    title: "Score",
                                    // color: AppColors.white,
                                  ),
                                  const Spacer(),
                                  LargeText(
                                    title: "340",
                                    // color: AppColors.white,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: height * .02),
                      LargeText(
                        title: 'Personal Details:',
                        color: AppColors.white,
                      ),
                      SizedBox(height: height * .02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: height * .13,
                            width: width * .3,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                children: [
                                  LargeText(
                                    title: "Age",
                                  ),
                                  const Spacer(),
                                  LargeText(
                                    title: age.toString(),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: height * .13,
                            width: width * .3,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                children: [
                                  LargeText(
                                    title: "Height",
                                    // color: AppColors.white,
                                  ),
                                  const Spacer(),
                                  LargeText(
                                    title: "1.8m",
                                    // color: AppColors.white,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
