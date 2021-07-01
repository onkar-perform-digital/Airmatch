import 'package:am_debug/UI/one-to-one%20chatting/ConversationScreen.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:am_debug/helpers/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:am_debug/Services/Database.dart';
import './MembersModel.dart';

class MembersList extends StatefulWidget {
  String grpname;
  MembersList({this.grpname});

  @override
  _MembersListState createState() => _MembersListState();
}

// For showing members in a Chat grp from firestore. 
// Currently not using since the chatting service has been changed to StreamChat
class _MembersListState extends State<MembersList> {
  @override
  void initState() {
    super.initState();
    print(widget.grpname);
    getMembers();
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createPersonalChatroom(String userPhoneNo) {
    if (userPhoneNo != Constants.phoneno) {
      String chatRoomId = getChatRoomId(userPhoneNo, Constants.phoneno);

      List<String> users = [userPhoneNo, Constants.phoneno];

      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatroomId': chatRoomId,
      };

      DatabaseMethods().createChatroom(chatRoomId, chatRoomMap);

      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return ConversationScreen(chatRoomId);
        },
      ));
    } else {
      print('You cannot send message to yourself');
    }
  }

  final List<MembersModel> members = [];

  getMembers() async {
    var grpdoc = await FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.grpname)
        .get();

    List<dynamic> grpmembers;

    if (grpdoc.exists) {
      grpmembers = grpdoc.data()["members"];

      grpmembers.forEach((element) async {
        String uid = element.substring(0, element.indexOf("_"));

        var userdoc =
            await FirebaseFirestore.instance.collection("users").doc(uid).get();

        MembersModel membersModel = MembersModel();

        membersModel.name =
            userdoc.data()["First name"] + " " + userdoc.data()["Last name"];
        membersModel.phoneno = userdoc.data()["Phone Number"];
        membersModel.image = userdoc.data()["Profile Image URL"];

        members.add(membersModel);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All members"),
          actions: [
            Text("Members Count"),
          ],
        ),
        body: Container(
            child: members.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: members.length,
                    itemBuilder: (BuildContext context, int index) {
                      print("${members[index].name}");
                      return memberTile(
                        members[index].name,
                        members[index].image,
                        members[index].phoneno,
                      );
                    },
                  )
                : Loading()));
  }

  Widget memberTile(String name, String imgUrl, String phoneNo) {
    return ListTile(
      title: Text(name),
      trailing: GestureDetector(
          onTap: () {
            createPersonalChatroom(phoneNo);
          },
          child: Icon(
            Icons.message_rounded,
            color: Color(Constants.blueClr),
          )),
      //  leading: CircleAvatar(
      //    backgroundImage: NetworkImage("https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"),
      //  ),
    );
  }
}
