import 'package:am_debug/Services/analytics_service.dart';
import 'package:am_debug/Services/getstream.dart';
import 'package:am_debug/UI/Dashboard/Profilepage.dart';
import 'package:am_debug/UI/City GroupChat/citygroupchat.dart';
import 'package:am_debug/UI/one-to-one%20chatting/Chat.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:am_debug/helpers/helperfunctions.dart';
import 'package:am_debug/helpers/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:am_debug/UI/Trips/trips.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../Sign In/LoginScreen.dart';

class DashboardScreen extends StatefulWidget {
  var pageIndex = 1;
  DashboardScreen(this.pageIndex);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  //String uid = "";
  String profilePicUrl;
  String name;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    HelperFunctions.saveUserLoggedInPreferenceKey(true);
    print(Constants.uid);

    //getStreamId();
    getUsername();
  }

  getUid() async {
    Constants.uid = await HelperFunctions.getUidPreferenceKey();
    print(Constants.uid);
  }

  getPhoneNo() async {
    Constants.phoneno = await HelperFunctions.getPhonenoPreferenceKey();
    print(Constants.phoneno);
  }

  Future<DocumentSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.uid)
        .get();
  }

  getUsername() async {
    await getData().then((value) {
      Constants.myname = (value.data() as Map)["First name"];
      print(Constants.myname);
    });
  }

  //   getStreamId() async{
  //    await getData().then((value) {
  //     Constants.streamId = (value.data() as Map)["Stream Id"];
  //     Constants.streamId = Constants.streamId.toString().substring(0, Constants.streamId.toString().length-11);
  //     print("Stream Id: ${Constants.streamId}");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    getUid();
    getPhoneNo();
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

          // For getting data in Drawer from Firestore
          drawer: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Constants.myname = (snapshot.data.data() as Map)['First name'];
                print(Constants.myname);
                return Drawer(
                    elevation: 1.5,
                    child: Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                  settings:
                                      RouteSettings(name: 'Profile Screen')));
                        },
                        child: DrawerHeader(
                          child: Row(children: [
                            Container(
                                height: 80,
                                width: 80,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      "${(snapshot.data.data() as Map)['Profile Image URL']}",
                                      fit: BoxFit.cover,
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                "${(snapshot.data.data() as Map)['First name']}")
                          ]),
                        ),
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
                            // Sign Out Functions
                            await FirebaseAuth.instance.signOut();
                            await AnalyticsService()
                                .userSignedOut(Constants.uid);
                            HelperFunctions.saveUserLoggedInPreferenceKey(
                                false);
                            HelperFunctions.saveUidPreferenceKey("");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                    settings:
                                        RouteSettings(name: 'Login Screen')),
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
