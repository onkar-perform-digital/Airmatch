import 'dart:ui';
import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/helpers/constants.dart';

import 'ConversationScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchController = TextEditingController();

  QuerySnapshot searchSnapshot;

  createChatroom({String userPhoneNo}) {
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

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                userPhoneNo: (searchSnapshot.docs[index].data()as  Map)['Phone Number'],
                userEmail: (searchSnapshot.docs[index].data() as Map)['uid'],
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods.getUser(searchController.text.toString()).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  getCasesDetailList(String query) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("PhoneNo cases", arrayContains: query)
        .get()
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  Widget searchTile({String userPhoneNo, String userEmail}) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userPhoneNo,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroom(userPhoneNo: userPhoneNo);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 11.0),
              child: Text(
                'Message',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).accentColor,
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (String query) {
                        getCasesDetailList(query);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type search here...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                              colors: [Colors.grey, Colors.blueGrey])),
                      height: 45.0,
                      width: 45.0,
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.blueGrey[100],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}
