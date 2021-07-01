import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/UI/Dashboard/DashboardScreen.dart';
import 'package:am_debug/UI/Registration/AddProfilePicture.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:am_debug/helpers/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();

  String phone;
  UserInformation({this.phone});
}

class _UserInformationState extends State<UserInformation> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String _chosenValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                      width: MediaQuery.of(context).size.width,
                      child:
                          Container(child: Lottie.asset('Assets/BG (1).json'))),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    top: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 40),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            mediumText(
                              'Enter your full name',
                              Constants.blackClr,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: fnameController,
                              validator: (String value) {
                                if (value.length < 2) {
                                  return "Enter valid name of atleast 2 Chars";
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "First Name",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: lnameController,
                              validator: (String value) {
                                if (value.length < 2) {
                                  return "Enter valid name of atleast 2 Chars";
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "Last Name",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                mediumText(
                                  'Date of Birth',
                                  Constants.blackClr,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: InkWell(
                                    onTap: () async {
                                      DateTime date = DateTime(1900);
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());

                                      date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));

                                      // dateCtl.text = date.toIso8601String();
                                      dateController.text = date
                                          .toIso8601String()
                                          .substring(0, 10);
                                    },
                                    child: mediumText(
                                        'Calender', Constants.blueClr),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: dateController,
                              validator: (String value) {
                                if (value == null || value == "") {
                                  return "Select yourn birth Date";
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                enabled: false,
                                filled: true,
                                hintText: "yy-mm-dd",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            mediumText(
                              'Your Gender',
                              Constants.blackClr,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _chosenValue,
                                  elevation: 5,
                                  style: TextStyle(color: Colors.black),
                                  items: <String>[
                                    'Male',
                                    'Female',
                                    'Other',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    "Select Gender\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                    style: TextStyle(
                                      //: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      _chosenValue = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: RaisedButton(
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddProfilePicture(
                                                      fname: fnameController
                                                          .text
                                                          .toString(),
                                                      lname: lnameController
                                                          .text
                                                          .toString(),
                                                      dob: dateController.text
                                                          .toString(),
                                                      gender: _chosenValue
                                                          .toString(),
                                                      uid: Constants.uid,
                                                      phone: widget.phone
                                                          .toString(),
                                                    ),
                                                settings: RouteSettings(
                                                    name:
                                                        'Upload Pic Screen')));
                                      }
                                    },
                                    child: const Text(
                                      'Next',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}