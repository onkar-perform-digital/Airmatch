import 'dart:io';

import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/UI/Dashboard/DashboardScreen.dart';
import 'package:am_debug/helpers/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class AddProfilePicture extends StatefulWidget {
  @override
  _AddProfilePictureState createState() => _AddProfilePictureState();

  String fname, lname, dob, gender, uid, phone;
  AddProfilePicture(
      {this.fname, this.lname, this.dob, this.gender, this.uid, this.phone});
}

class _AddProfilePictureState extends State<AddProfilePicture> {
  String imageUrl = "";
  File selectedImage;
  final picker = ImagePicker();
  bool _loading = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadData() async {
    // make sure we have image
    if (selectedImage != null) {
      setState(() {
        _loading = true;
      });
      // upload image
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference storageReference = storage
          .ref()
          .child("Images/${widget.uid}/${Path.basename(selectedImage.path)}");

      UploadTask uploadTask = storageReference.putFile(selectedImage);

      // get download url
      await uploadTask.whenComplete(() async {
        try {
          imageUrl = await storageReference.getDownloadURL();
          print(imageUrl);
        } catch (e) {
          print(e);
        }
      });
      await DatabaseMethods()
          .uploadtoDB(widget.fname, widget.lname, widget.gender, widget.dob,
              imageUrl.toString(), widget.uid, widget.phone)
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen(1)),
              (route) => false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading == true
        ? Loading()
        : Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              DatabaseMethods()
                              .uploadtoDB(
                                  widget.fname,
                                  widget.lname,
                                  widget.gender,
                                  widget.dob,
                                  "",
                                  widget.uid,
                                  widget.phone)
                              .then((value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashboardScreen(1)),
                                  (route) => false));
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.underline,
                                  fontSize: 15),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  selectedImage == null
                      ? RawMaterialButton(
                          onPressed: () {
                            getImage();
                          },
                          elevation: 5.0,
                          fillColor: Colors.white,
                          child: SvgPicture.asset(
                              'Assets/Profile_picture_add.svg'),
                          padding: EdgeInsets.all(55.0),
                          shape: CircleBorder(),
                        )
                      : RawMaterialButton(
                          onPressed: () {},
                          elevation: 5.0,
                          fillColor: Colors.white,
                          child: Image.file(
                            selectedImage,
                            fit: BoxFit.cover,
                            cacheHeight: 100,
                            cacheWidth: 100,
                          ),
                          padding: EdgeInsets.all(55.0),
                          shape: CircleBorder(),
                        ),
                  SizedBox(height: 30),
                  Text(
                    'Add a Profile Picture',
                    style: TextStyle(fontSize: 18),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 100,
                      child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () async {
                          await uploadData();
                        },
                        child: const Text(
                          'Upload',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
