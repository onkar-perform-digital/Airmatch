import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './citychat_page.dart';

class CityGroupChat extends StatefulWidget {
  const CityGroupChat({ Key key }) : super(key: key);

  @override
  _CityGroupChatState createState() => _CityGroupChatState();
}

class _CityGroupChatState extends State<CityGroupChat> {

  // data
  //final AuthService _auth = AuthService();
  // User _user;
  String _groupName;
  // String _userName = '';
  // String _email = '';
  Stream _groups;


  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }


  // widgets
  Widget noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _popupDialog(context);
            },
            child: Icon(Icons.add_circle, color: Colors.grey[700], size: 75.0)
          ),
          SizedBox(height: 20.0),
          Text("You've not joined any group, tap on the 'add' icon to create a group or search for groups by tapping on the search button below."),
        ],
      )
    );
  }



  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data['City groups'] != null) {
            print(snapshot.data['City groups'].length);
            if(snapshot.data['City groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['City groups'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  int reqIndex = snapshot.data['City groups'].length - index - 1;
                  return GroupTile(userName: snapshot.data['First name'], groupId: snapshot.data['City groups'][reqIndex], groupName: snapshot.data['City groups'][reqIndex]);
                }
              );
            }
            else {
              return noGroupWidget();
            }
          }
          else {
            return noGroupWidget();
          }
        }
        else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    );
  }


  // functions
  _getUserAuthAndJoinedGroups() async {
    //_user = await FirebaseAuth.instance.currentUser;
    await Firebase.initializeApp();
    await DatabaseMethods().getUserCityGroups().then((snapshots) {
      print(snapshots);
      setState(() {
        _groups = snapshots;
        print(snapshots);
      });
    });
  }


  // String _destructureId(String res) {
  //   // print(res.substring(0, res.indexOf('_')));
  //   return res.substring(0, res.indexOf('_'));
  // }


  // String _destructureName(String res) {
  //   // print(res.substring(res.indexOf('_') + 1));
  //   return res.substring(res.indexOf('_') + 1);
  // }


  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed:  () async {
        if(_groupName != null) {
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
        style: TextStyle(
          fontSize: 15.0,
          height: 2.0,
          color: Colors.black             
        )
      ),
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


  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: groupsList(),
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
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => CityChatPage(groupId: groupName, userName: userName, groupName: groupName,)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.blueAccent,
            child: Text(groupName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join the conversation as $userName", style: TextStyle(fontSize: 13.0)),
        ),
      ),
    );
  }
}
