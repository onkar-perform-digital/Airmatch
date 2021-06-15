import 'package:am_debug/UI/Dashboard/Profilepage.dart';
import 'package:am_debug/UI/one-to-one%20chatting/Chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:am_debug/UI/Trips/trips.dart';
import '../Sign In/LoginScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String uid = "";

  @override
  void initState() {
    super.initState();
    //uid = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blue),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(
                Icons.account_box,
                color: Color(0xFF358EE8),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            IconButton(
              
              icon: Icon(
                
                Icons.add_alert,
                color: Colors.blue,
              ),
              onPressed: () {},
            )
          ],
          bottom: TabBar(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black12,
            ),
            tabs: [
              Tab(
                  child: Text(
                "Groups",
                style: TextStyle(
                  color: Colors.blue,
                ),
              )),
              Tab(
                  child: Text(
                "Trips",
                style: TextStyle(
                  color: Colors.blue,
                ),
              )),
              Tab(
                  child: Text(
                "Messages",
                style: TextStyle(
                  color: Colors.blue,
                ),
              )),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  children: [
                    Text("dnfjgkdsf"),
                    Text("dnfjgkdsf")
                  ],
                )
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.directions_car),
            Trip(),
            Chat()
          ],
        ),
      ),
    );
  }
}

// IconButton(
//   icon: Icon(Icons.logout),
//   onPressed: () async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//         (route) => false);
//   },
// )
