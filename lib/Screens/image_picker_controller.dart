// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class ImagePickerController extends GetxController {
//   RxString imagePath = ''.obs;
//   Future getImage() async {
//     final ImagePicker imagePicker = ImagePicker();
//     final image = await imagePicker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       imagePath.value = image.path.toString();
//     }
//   }

//   // RxString _imagePath = ''.obs;
//   Future pickImage() async {
//     final ImagePicker imagePicker = ImagePicker();
//     final image = await imagePicker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       imagePath.value = image.path.toString();
//     }
//   }

// // Future<String> getImageName(String imagePath) async {
// //   await Future.delayed(const Duration(seconds: 1));
// //   List<String> pathParts = imagePath.split('/');
// //   String imageName = pathParts.last;
// //   return imageName;
// // }
// }