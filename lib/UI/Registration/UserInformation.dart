import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/UI/Dashboard/DashboardScreen.dart';
import 'package:am_debug/UI/Registration/AddProfilePicture.dart';
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

  var uid;

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser.uid;
    print(uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
              child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                  width: MediaQuery.of(context).size.width,
                  child: Container(child: Lottie.asset('Assets/BG (1).json'))),
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
                        Text(
                          'Enter your full name',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: fnameController,
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
                        TextField(
                          controller: lnameController,
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
                            Text(
                              'Date of Birth',
                              style: TextStyle(fontSize: 16),
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
                                  dateController.text =
                                      date.toIso8601String().substring(0, 10);
                                },
                                child: Text(
                                  'Calender',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF5ab9b9)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: dateController,
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
                        Text(
                          'Your Gender',
                          style: TextStyle(fontSize: 16),
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
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text(
                                "Select Gender\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                style: TextStyle(
                                  //: Colors.blue,
                                  fontSize: 18,
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
                              width: MediaQuery.of(context).size.width - 100,
                              child: RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddProfilePicture(fname: fnameController.text.toString(), lname: lnameController.text.toString(), dob: dateController.text.toString(), gender: _chosenValue.toString(),
                                          uid: uid.toString(), phone: widget.phone.toString(),
                                          )));
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
    ));
  }
}

// Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width - 10,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: TextField(
//                 controller: nameController,
//                 decoration:
//                     InputDecoration(hintText: "Enter Name", filled: true),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: TextField(
//                 controller: citynameController,
//                 decoration:
//                     InputDecoration(hintText: "Enter your City", filled: true),
//               ),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Container(
//               margin: EdgeInsets.all(10),
//               width: 300,
//               child: FlatButton(
//                 color: Colors.blue,
// onPressed: () {
  // DatabaseMethods()
  //     .uploadtoDB(nameController.text.toString(),
  //         citynameController.text.toString(), uid)
  //     .then((value) => Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => DashboardScreen()),
  //         (route) => false));
// },
//                 child: Text(
//                   'Next',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
