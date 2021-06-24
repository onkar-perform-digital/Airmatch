import 'package:age/age.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:am_debug/helpers/loading.dart';
import 'package:am_debug/helpers/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //var uid = "";

  TextEditingController statusCtlr = TextEditingController();
  int totalFlights;

  calculateAge(String bday) {
    AgeDuration age = Age.dateDifference(
        fromDate: DateTime.parse(bday),
        toDate: DateTime.now(),
        includeToDate: false);
    return age.years;
  }

  totalFlightsTaken() async {
    totalFlights = await FirebaseFirestore.instance.collection("users").doc(Constants.uid).collection("User Travel Info").snapshots().length;
    print(totalFlights.toString());
  }

  @override
  void initState() {
    totalFlightsTaken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateStatus(String status) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Constants.uid)
          .update({'status': status});
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: mediumText("Profile Page", Constants.blackClr),
          iconTheme: IconThemeData(color: Color(Constants.blueClr)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(Icons.edit),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid', isEqualTo: Constants.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                final List<DocumentSnapshot> documents = snapshot.data.docs;
                return snapshot.hasData
                    ? ListView(
                        children: documents
                            .map((doc) => Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20),
                                        Container(
                                            width: 160.0,
                                            height: 160.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        "${doc['Profile Image URL']}")))),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            mediumText(
                                                "${doc['First name']} ${doc['Last name']}",
                                                Constants.blueClr),
                                            mediumText(
                                                "${calculateAge(doc['Date of Birth'])} years",
                                                0xFFB4B4B4),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          controller: statusCtlr,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                              enabled: true,
                                              filled: true,
                                              border: InputBorder.none,
                                              hintText:
                                                  "Enter your status here",
                                              hintStyle: TextStyle(
                                                fontStyle: FontStyle.italic,
                                              )),
                                          onSubmitted: (value) {
                                            updateStatus(value.toString());
                                          },
                                          textInputAction: TextInputAction.done,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          color: Color(0xFFF2F2F2),
                                          height: 100,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Total flights taken"),
                                                  Text(totalFlights.toString()),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Total flights taken")
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Total flights taken")
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                ))
                            .toList())
                    : Loading();
              }),
        ),
      ),
    );
  }
}
