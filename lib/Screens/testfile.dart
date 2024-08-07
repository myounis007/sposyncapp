// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:soccer_app/Screens/Widgets/custom_textfield.dart';

// import 'Widgets/round_button.dart';
// import 'image_picker_controller.dart';

// class DocumentsScreen extends StatefulWidget {
//   const DocumentsScreen({super.key});

//   @override
//   State<DocumentsScreen> createState() => _DocumentsScreenState();
// }

// class _DocumentsScreenState extends State<DocumentsScreen> {
//   ImagePickerController controller = Get.put(ImagePickerController());

//   // ImagePicker instance
//   final ImagePicker _picker = ImagePicker();

//   // Image Name and Path Variables
//   String? _imageName1;
//   String? _imagePath1;

//   String? _imageName2;
//   String? _imagePath2;

//   String? _imageName3;
//   String? _imagePath3;

//   String? _imageName4;
//   String? _imagePath4;

//   String? _imageName5;
//   String? _imagePath5;

//   // Funtion to pick image through gallery
//   Future<void> pickImage(int imageIndex) async {
//     final XFile? pickedImage =
//         await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _setImageNameAndPath(imageIndex, pickedImage.name, pickedImage.path);
//       });
//     }
//   }

//   // Funtion to pick image through camera
//   Future<void> getImage(int imageIndex) async {
//     final XFile? pickedImage =
//         await _picker.pickImage(source: ImageSource.camera);
//     if (pickedImage != null) {
//       setState(() {
//         _setImageNameAndPath(imageIndex, pickedImage.name, pickedImage.path);
//       });
//     }
//   }

//   void _setImageNameAndPath(int index, String name, String path) {
//     switch (index) {
//       case 1:
//         _imageName1 = name;
//         _imagePath1 = path;
//         break;
//       case 2:
//         _imageName2 = name;
//         _imagePath2 = path;
//         break;
//       case 3:
//         _imageName3 = name;
//         _imagePath3 = path;
//         break;
//       case 4:
//         _imageName4 = name;
//         _imagePath4 = path;
//         break;
//       case 5:
//         _imageName5 = name;
//         _imagePath5 = path;
//         break;
//     }
//   }

//   void showImage(BuildContext context, String? imagePath) {
//     if (imagePath != null) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           content: Image.file(File(imagePath)),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.sizeOf(context).height;
//     double width = MediaQuery.sizeOf(context).width;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Document'.tr,
//           // 'doc1'.tr,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           children: [
//             buildImagePickerTile(
//                 context,
//                 height * 1.2,
//                 width,
//                 'Selfie with your drivers license'.tr,
//                 1,
//                 _imageName1,
//                 _imagePath1),
//             SizedBox(height: height * 0.02),
//             buildImagePickerTile(
//                 context,
//                 height * 1.2,
//                 width,
//                 'Vehicle Registration Certificate'.tr,
//                 2,
//                 _imageName2,
//                 _imagePath2),
//             SizedBox(height: height * 0.02),
//             buildImagePickerTile(
//                 context,
//                 height * 1.2,
//                 width,
//                 'Vehicle photo with VRC certificate and license'.tr,
//                 3,
//                 _imageName3,
//                 _imagePath3),
//             SizedBox(height: height * 0.02),
//             buildImagePickerTile(context, height * 1.2, width, 'Insurance'.tr,
//                 4, _imageName4, _imagePath4),
//             SizedBox(height: height * 0.02),
//             buildImagePickerTile(
//                 context,
//                 height * 1.2,
//                 width,
//                 'Passenger license (if applicable)'.tr,
//                 5,
//                 _imageName5,
//                 _imagePath5),
//             SizedBox(height: height * 0.04),
//             RoundButton(
//                 title: 'SAVE', onPressed: () {}, color: Colors.deepPurple),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildImagePickerTile(BuildContext context, double height, double width,
//       String title, int index, String? imageName, String? imagePath) {
//     return Container(
//       height: height * 0.08,
//       width: width,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade400),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: CustomTextTField(
//         onTap: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (context) {
//               return Container(
//                 height: height * 0.3,
//                 width: width,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Add photo'.tr,
//                           // 'doc2'.tr,
//                           style: const TextStyle(
//                               fontSize: 16, color: Colors.deepPurple),
//                         ),
//                         ListTile(
//                           onTap: () {
//                             getImage(index);
//                           },
//                           title: Text('Camera'.tr),
//                           // child: Text('doc5'.tr),
//                         ),
//                         ListTile(
//                           onTap: () {
//                             pickImage(index);
//                           },
//                           title: Text('Gallery'.tr),
//                           // child: Text('doc5'.tr),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         prefixIcon: Icons.attach_file, readOnly: true,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title),
//               if (imageName != null)
//                 TextButton(
//                   onPressed: () {
//                     showImage(context, imagePath);
//                   },
//                   child: Text(
//                     imageName,
//                     maxLines: 1,
//                     style: const TextStyle(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         // suffixIcon: Image.asset(
//         //   'assets/icon.jpg',
//         //   height: height * 0.03,
//         // ),
//       ),
//     );
//   }
// }
