import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/Services/analytics_service.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './citychat_page.dart';

class CityGroupChat extends StatefulWidget {
  const CityGroupChat({Key key}) : super(key: key);

  @override
  _CityGroupChatState createState() => _CityGroupChatState();
}

class _CityGroupChatState extends State<CityGroupChat> {
  //final AuthService _auth = AuthService();
  // User _user;
  String _groupName;
  Stream _groups;

  @override
  void initState() {
    FirebaseAnalytics().setCurrentScreen(screenName: 'City Grp Chat');
    super.initState();
    print("Initiated");
    _getUserAuthAndJoinedGroups();
  }

  // Used to indicate where there are no groups formed
  Widget noGroupWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  _popupDialog(context);
                },
                child: Icon(Icons.add_circle,
                    color: Colors.grey[700], size: 75.0)),
            SizedBox(height: 20.0),
          ],
        ));
  }

  // Get User joined groups
  _getUserAuthAndJoinedGroups() async {
    //_user = await FirebaseAuth.instance.currentUser;

    // After arriving on Dashboard Screen made all previous routes false.
    // Hence need to Initialize firebase again
    await Firebase.initializeApp();
    await DatabaseMethods().getUserCityGroups().then((snapshots) {
      print(snapshots);
      setState(() {
        _groups = snapshots;
        print(snapshots);
      });
    });
  }

  // Only for testing group creation
  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed: () async {
        if (_groupName != null) {
          DatabaseMethods().createCityGroup(Constants.uid, _groupName);
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _groups,
        builder: (context, snapshot) {
          return snapshot.data['City groups'] != null
              ? ListView.builder(
                  itemCount: snapshot.data['City groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex =
                        snapshot.data['City groups'].length - index - 1;
                    return GroupTile(
                        userName: snapshot.data['First name'],
                        groupId: snapshot.data['City groups'][reqIndex],
                        groupName: snapshot.data['City groups'][reqIndex]);
                  })
              : noGroupWidget();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white, size: 30.0),
        backgroundColor: Colors.grey[700],
        elevation: 0.0,
      ),
    );
  }
}

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;

  GroupTile({this.userName, this.groupId, this.groupName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await AnalyticsService().grpViews(groupName, Constants.uid);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CityChatPage(
                      groupId: groupName,
                      userName: userName,
                      groupName: groupName,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.blueAccent,
            child: Text(groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white)),
          ),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
