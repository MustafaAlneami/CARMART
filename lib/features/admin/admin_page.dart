import 'dart:io';
import 'package:carmart/core/components/custom_button.dart';

import 'package:carmart/core/components/custom_text_field.dart';
import 'package:carmart/core/components/snack.dart';
import 'package:carmart/features/admin/widgets/custom_dropdown_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class AdminPageView extends StatefulWidget {
  const AdminPageView({super.key});

  @override
  State<AdminPageView> createState() => _AdminPageViewState();
}

class _AdminPageViewState extends State<AdminPageView> {
  TextEditingController _model = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _engine = TextEditingController();
  TextEditingController _speed = TextEditingController();
  TextEditingController _seats = TextEditingController();
  //List<String> availableColors = ['Black', 'Red', 'Blue'];
  List<String> brands = [
    'All',
    'Bmw',
    'Lamborghini',
    'Audi',
    'Shelby',
    'Dodge',
    'Mercedes'
  ];
  String? selectedBrand;
  File? _image;
  bool isLoading = false;
//
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<File> _compressImage(File imageFile) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    final compressedImage = img.encodeJpg(image!, quality: 70);
    final tempDir = await Directory.systemTemp.createTemp();
    final compressedFile = File('${tempDir.path}/compressed.jpg');
    await compressedFile.writeAsBytes(compressedImage);
    return compressedFile;
  }

  Future<void> _uploadCar() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (_image == null) return;
      File compressedImage = await _compressImage(_image!);
      String imageUrl = await _uploadImage(compressedImage);
      await FirebaseFirestore.instance.collection('cars').add({
        'model': _model.text,
        'price': _price.text,
        'engine': _engine.text,
        'speed': _speed.text,
        'seats': _seats.text,
        'brand': selectedBrand,
        'image': imageUrl,
      });
      setState(() {
        isLoading = false;
      });
      Snack().success(context, "Car Added Successfully");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Snack().error(context, e.toString());
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('cars/${DateTime.now()}.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
          title: Text(
            "Admin Page",
          ),
          backgroundColor: Colors.grey.shade300),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            /// colors
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _pickImage();
                    });
                  },
                  child: Icon(CupertinoIcons.share_up),
                ),
              ],
            ),
            SizedBox(height: 20),

            /// car details
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _engine,
                    hint: "Car Engine",
                    type: TextInputType.text,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    controller: _speed,
                    hint: "Car Speed",
                    type: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    controller: _seats,
                    hint: "Seats Number",
                    type: TextInputType.text,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _model,
              hint: "Car Model",
              type: TextInputType.text,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _price,
              hint: "Car Price",
              type: TextInputType.number,
            ),
            SizedBox(height: 20),
            CustomDropdownItem(
              value: selectedBrand ?? brands.first,
              valid: "please select at least one item",
              hint: "Choose Car Brand",
              items: brands
                  .map((brand) => DropdownMenuItem(
                        value: brand,
                        child: Text(brand),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedBrand = value as String;
                });
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              onTap: _uploadCar,
              width: double.infinity,
              height: 35,
              color: Colors.black87,
              radius: 8,
              child: Center(
                child: isLoading
                    ? CupertinoActivityIndicator(color: Colors.white)
                    : Text("Add Car", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:carmart/core/components/custom_button.dart';
// import 'package:carmart/core/components/custom_container.dart';
// import 'package:carmart/core/components/custom_text_field.dart';
// import 'package:carmart/features/admin/widgets/custom_dropdown_item.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;

// class AdminPageView extends StatefulWidget {
//   const AdminPageView({super.key});

//   @override
//   State<AdminPageView> createState() => _AdminPageViewState();
// }

// class _AdminPageViewState extends State<AdminPageView> {
//   List<String> availableCars = ['Red', 'Blue', 'Black'];
//   List<String> brands = ['Toyota', 'Honda', 'Ford'];
//   String? selectedBrand;
//   File? imageFile;
//   bool isLoading = false;
//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) setState(() => imageFile = File(pickedFile.path));
//   }

//   Future<void> uploadCarData() async {
//     if (imageFile == null) return;

//     final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     final storageRef =
//         FirebaseStorage.instance.ref().child('cars/$fileName.jpg');
//     await storageRef.putFile(imageFile!);
//     final imageUrl = await storageRef.getDownloadURL();

//     await FirebaseFirestore.instance.collection('cars').add({
//       'brand': selectedBrand,
//       'model': _modal.text,
//       'price': _price.text,
//       'engine': _engine.text,
//       'speed': _speed.text,
//       'seats': _seats.text,
//       'image': imageUrl,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   TextEditingController _modal = TextEditingController();
//   TextEditingController _price = TextEditingController();
//   TextEditingController _engine = TextEditingController();
//   TextEditingController _speed = TextEditingController();
//   TextEditingController _seats = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(
//         title: Text('Admin Page  bro'),
//         backgroundColor: Colors.grey.shade200,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CustomContainer(
//                     width: 40,
//                     height: 40,
//                     radius: 60,
//                     color: Colors.pink,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       _pickImage();
//                     },
//                     child: Icon(CupertinoIcons.share_up),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             //car details
//             Row(
//               children: [
//                 Expanded(
//                   child: CustomTextField(
//                       controller: _engine,
//                       hint: 'Car Engine',
//                       type: TextInputType.text),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: CustomTextField(
//                       controller: _speed,
//                       hint: 'Car Speed',
//                       type: TextInputType.number),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: CustomTextField(
//                       controller: _seats,
//                       hint: 'Seats Number',
//                       type: TextInputType.number),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             CustomTextField(
//                 controller: _modal,
//                 hint: 'Car Model',
//                 type: TextInputType.text),
//             SizedBox(
//               height: 20,
//             ),
//             CustomTextField(
//                 controller: _price,
//                 hint: 'Car Price',
//                 type: TextInputType.number),
//             SizedBox(
//               height: 20,
//             ),
//             CustomDropdownItem(
//               value: selectedBrand ?? brands.first,
//               valid: 'Please select at least one item',
//               hint: 'Car Brand',
//               items: brands
//                   .map((brand) =>
//                       DropdownMenuItem(value: brand, child: Text(brand)))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedBrand = value as String;
//                 });
//               },
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             CustomButton(
//               onTap: () {
//                 uploadCarData();
//               },
//               width: double.infinity,
//               height: 35,
//               color: Colors.black87,
//               radius: 8,
//               child: Center(
//                 child: isLoading
//                     ? CupertinoActivityIndicator(color: Colors.white)
//                     : Text(
//                         'Add Car ',
//                         style: TextStyle(color: Colors.white),
//                       ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
