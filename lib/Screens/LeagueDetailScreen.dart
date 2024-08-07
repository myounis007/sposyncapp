// // ignore_for_file: prefer_const_constructors, must_be_immutable, implicit_call_tearoffs

// import 'package:flutter/material.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:soccer_app/Screens/Widgets/text_widget.dart';
// import '../edit_and_view_ofroles/Coach/coach_screen.dart';
// import 'Widgets/app_colors.dart';
// import 'Widgets/custom_textfield.dart';

// class CoachDashboardScreen extends StatefulWidget {
//   const CoachDashboardScreen({super.key});

//   @override
//   State<CoachDashboardScreen> createState() => _CoachDashboardScreenState();
// }

// class _CoachDashboardScreenState extends State<CoachDashboardScreen> {
//   List<dynamic> leaguesName = [
//     'Create League ',
//     'Create League ',
//     'Create League ',
//     'Create League ',
//   ];

//   // Controllers
//   TextEditingController league = TextEditingController();
//   TextEditingController venue = TextEditingController();
//   TextEditingController player = TextEditingController();
//   TextEditingController role = TextEditingController();
//   TextEditingController duration = TextEditingController();
//   TextEditingController time = TextEditingController();
//   TextEditingController team = TextEditingController();
//   TextEditingController umpire = TextEditingController();

//   // Formkey
//   final formkey = GlobalKey<FormState>();

//   bool createLeague = false;

//   void _addLeague() {
//     if (formkey.currentState!.validate()) {
//       setState(() {
//         leaguesName.add(league.text);
//         league.clear();
//         venue.clear();
//         player.clear();
//         role.clear();
//         duration.clear();
//         time.clear();
//         team.clear();
//         umpire.clear();
//         createLeague = false;
//       });
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.sizeOf(context).height;
//     double width = MediaQuery.sizeOf(context).width;
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       drawer: Drawer(
//         child: Container(
//           height: height,
//           width: double.infinity,
//           decoration: BoxDecoration(color: AppColors.white),
//           child: Column(
//             children: [
//               SizedBox(height: height * .04),
//               CircleAvatar(
//                 radius: height * .05,
//                 backgroundImage: AssetImage('assets/images/khan.jpeg'),
//               ),
//               const Divider(),
//               ListTile(
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => CoachScreen()));
//                 },
//                 leading: Icon(Icons.account_circle),
//                 title: MediumText(title: 'Profile'),
//               ),
//               const Spacer(),
//               SmallText(
//                   fontSize: 12, title: 'Terms and condition | Privacy Policy'),
//               SizedBox(height: height * .02)
//             ],
//           ),
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         centerTitle: true,
//         title: LargeText(title: 'Coach Dashboard'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     MediumText(title: 'Create Leagues!',fontSize: 12,),
//                     TextButton(onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             backgroundColor: AppColors.white,
//                             content: SingleChildScrollView(
//                               child: Form(
//                                 key: formkey,
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: CustomTextTField(
//                                             readOnly: false,
//                                             onTap: () {},
//                                             hintText: 'League Name',
//                                             controller: league,
//                                             validator: RequiredValidator(
//                                                 errorText:
//                                                 'Please enter league name'),
//                                           ),
//                                         ),
//                                         SizedBox(width: width * 0.02),
//                                         Expanded(
//                                           child: CustomTextTField(
//                                             readOnly: false,
//                                             onTap: () {},
//                                             hintText: 'Venue',
//                                             controller: venue,
//                                             validator: RequiredValidator(
//                                                 errorText:
//                                                 'Please enter venue'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: height * .01),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: CustomTextTField(
//                                             readOnly: false,
//                                             onTap: () {},
//                                             hintText: 'Player',
//                                             controller: player,
//                                             validator: RequiredValidator(
//                                                 errorText:
//                                                 'Please enter players name'),
//                                           ),
//                                         ),
//                                         SizedBox(width: width * 0.02),
//                                         Expanded(
//                                           child: CustomTextTField(
//                                             readOnly: false,
//                                             onTap: () {},
//                                             hintText: 'Role',
//                                             controller: role,
//                                             validator: RequiredValidator(
//                                                 errorText: 'Please enter role'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: height * 0.01),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: CustomTextTField(
//                                             readOnly: false,
//                                             onTap: () {},
//                                             hintText: 'Duration',
//                                             controller: duration,
//                                             validator: RequiredValidator(
//                                                 errorText:
//                                                 'Please enter duration '),
//                                           ),
//                                         ),
//                                         SizedBox(width: width * 0.02),
//                                         Expanded(
//                                           child: CustomTextTField(
//                                             readOnly: false,
//                                             hintText: 'Time Table',
//                                             controller: time,
//                                             validator: RequiredValidator(
//                                                 errorText:
//                                                 'Please enter time table '),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: height * .01),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: CustomTextTField(
//                                             readOnly: false,
//                                             hintText: 'Teams',
//                                             controller: team,
//                                             validator: RequiredValidator(
//                                                 errorText:
//                                                 'Please enter team name'),
//                                           ),
//                                         ),
//                                         SizedBox(width: width * 0.02),
//                                         Expanded(
//                                           child: CustomTextTField(
//                                             readOnly: false,
//                                             controller: umpire,
//                                             hintText: 'Umpires',
//                                             validator: RequiredValidator(
//                                                 errorText:
//                                                 'Please enter umpire'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: height * .01),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: _addLeague,
//                                 child: SmallText(
//                                   title: 'Create League',
//                                   color: AppColors.red,
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     }, child:  MediumText(title: 'Create Leagues',color: AppColors.red,))

//                   ]),
//               SizedBox(
//                 height: height * .01,
//               ),
//               SizedBox(
//                 height: height,
//                 width: width,
//                 child: GridView.builder(

//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: height*.14),
//                   // scrollDirection: Axis.horizontal,
//                   itemCount: leaguesName.length,
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: (){},
//                       child: Container(

//                         margin: EdgeInsets.all(8.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 5,
//                               offset: Offset(2, 4),
//                             ),
//                           ],
//                         ),
//                         child:
//                         Center(child: SmallText(title: leaguesName[index])),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }