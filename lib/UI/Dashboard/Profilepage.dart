import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var uid = "";

    @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<DocumentSnapshot> documents = snapshot.data.docs;
                return ListView(
                    children: documents
                        .map((doc) => Column(children: [
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
                              Text(
                                "UID: ${doc['uid']}",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "DOB: ${doc['Date of Birth']}",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Name:  ${doc['First name']} ${doc['Last name']}",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "Gender: ${doc['Gender']}",
                                style: TextStyle(fontSize: 18),
                              ),
                            ]))
                        .toList());
              } else if (snapshot.hasError) {
                print("Error");
              }
            }),
      ),
    );
  }
}
