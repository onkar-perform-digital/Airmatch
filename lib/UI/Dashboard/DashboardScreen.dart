import 'package:am_debug/UI/Dashboard/Profilepage.dart';
import 'package:am_debug/UI/City GroupChat/citygroupchat.dart';
import 'package:am_debug/UI/one-to-one%20chatting/Chat.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:am_debug/helpers/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:am_debug/UI/Trips/trips.dart';
import '../Sign In/LoginScreen.dart';

class DashboardScreen extends StatefulWidget {
  var pageIndex = 1;
  DashboardScreen(this.pageIndex);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  String uid = "";
  String profilePicUrl;
  String name;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    //getNameAndProfilepic();
    //uid = FirebaseAuth.instance.currentUser.uid;
    _tabController = new TabController(length: 3, vsync: this);
  }

  Future<DocumentSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: widget.pageIndex,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.blue),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            actions: [
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
                Tab(child: smallText("Groups", Constants.blueClr)),
                Tab(child: smallText("Trips", Constants.blueClr)),
                Tab(child: smallText("Messages", Constants.blueClr)),
              ],
            ),
          ),
          drawer: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Constants.myname = snapshot.data.data()['First name'];
                return Drawer(
                    elevation: 1.5,
                    child: Column(children: [
                      DrawerHeader(
                        child: Row(children: [
                          Container(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    "${snapshot.data.data()['Profile Image URL']}",
                                    fit: BoxFit.cover,
                                  ))),
                          SizedBox(
                            width: 10,
                          ),
                          Text("${snapshot.data.data()['First name']}")
                        ]),
                      ),
                      Expanded(
                          child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          ListTile(
                            title: mediumText("Setting", Constants.blueClr),
                            leading: Icon(Icons.settings),
                            onTap: () {},
                          ),
                          ListTile(
                            title: mediumText(
                                'Reffer a Friend', Constants.blueClr),
                            leading: Icon(Icons.family_restroom_sharp),
                            onTap: () {},
                          ),
                          ListTile(
                              title: mediumText('Support', Constants.blueClr),
                              leading: Icon(Icons.support_agent_sharp),
                              onTap: () {})
                        ],
                      )),
                      Container(
                        color: Colors.black,
                        width: double.infinity,
                        height: 0.1,
                      ),
                      ListTile(
                          title: mediumText('Log Out', Constants.blueClr),
                          leading: Icon(Icons.exit_to_app),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (route) => false);
                          })
                    ]));
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Text("No data");
              }
              return CircularProgressIndicator();
            },
          ),
          body: TabBarView(
            children: [CityGroupChat(), Trip(), Chat()],
          ),
        ));
  }
}
