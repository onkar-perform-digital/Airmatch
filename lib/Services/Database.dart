import 'package:am_debug/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as st;

class DatabaseMethods {
  // Get current signedIn user
  Future<User> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }


  // Search Result: get user from phone no cases
  getUser(String phone) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('PhoneNo cases', arrayContains: phone)
        .get();
  }


  // Upload new user data Function
  uploadUserInfo(String uid, Map userInfo) async {
    print('$uid');
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.uid)
        .set(userInfo);
  }


  // Upload travel Info function
  uploadTravelInfo(String uid, Map userInfo, String from, String to,
      String airlineNo) async {
    print('$uid');
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("User Travel Info")
        .doc("$from -> $to : $airlineNo")
        .set(userInfo);
  }


  // To-be done for edit user profile
  /*
  Future updateInfo(String uid, String date, String city) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "DOB": date,
      "city": city,
    }).catchError((error) {
      print(error);
    });
  }
  */


  // Upload new user Map generator function
  Future<void> uploadtoDB(String fname, String lname, String gender, String dob,
      String profileUrl, var uid, String phone) async {
    setSearchParam(String phoneno) {
      String number = phoneno;
      List<String> listnumber = number.split("");
      List<String> output = [];
      for (int i = 0; i < listnumber.length; i++) {
        if (i != listnumber.length - 1) {
          output.add(listnumber[i]);
        }
        List<String> temp = [listnumber[i]];
        for (int j = i + 1; j < listnumber.length; j++) {
          temp.add(listnumber[j]);
          output.add(temp.join());
        }
      }
      print(output.toString());
      return output;
    }

    final user = st.User(id: fname.toString(), extraData: {
      "name": phone.toString(),
      "image": profileUrl.toString(),
    });

    await Constants.client
        .connectUser(user, Constants.client.devToken(phone.toString()));
    print("ID: ${Constants.client.token}");

    if (uid != null) {
      Constants.uid = uid;
      Map<String, dynamic> userInfoMap = {
        "uid": uid,
        "First name": fname.toString(),
        "Last name": lname.toString(),
        "Date of Birth": dob.toString(),
        "Gender": gender.toString(),
        "Profile Image URL": profileUrl.toString(),
        "Phone Number": phone.toString(),
        "PhoneNo cases": setSearchParam(phone.toString()),
        "groups": [],
        "status": "",
        "City groups": [],
        "Stream Id": Constants.client.token,
      };

      await DatabaseMethods().uploadUserInfo(uid, userInfoMap);
    }
  }


  // New trip Map
  Future<void> uploadTriptoDB(String date, String travellingFrom, String travellingTo, String bookingNo, String airlineName, String airlineNo, String arrivalTime, String departureTime) async {
    if (Constants.uid != null) {
      Map<String, dynamic> tripInfoMap = {
        "Date": date,
        "Travelling from": travellingFrom.toString(),
        "Travelling to": travellingTo.toString(),
        "Booking No": bookingNo.toString(),
        "Flight Arrival time": arrivalTime.toString(),
        "Flight Departure time": departureTime.toString(),
        "Airline Name": airlineName.toString(),
        "Airline No": airlineNo.toString()
      };

      await DatabaseMethods().uploadTravelInfo(
          Constants.uid, tripInfoMap, travellingFrom, travellingTo, airlineNo);
    }
  }


  // Create one-to-one chat Room
  createChatroom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }


  // One-to-one chat messages
  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  
  //One-to-one chat get messages
  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }


  // One-to-one chat get chats
  getChatRooms(String phone) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: phone)
        .snapshots();
  }

  // create flight group chat
  Future createGroup(String userName, String groupName) async {
    await FirebaseFirestore.instance.collection('groups').doc(groupName).set({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupName)
        .update({
      'members': FieldValue.arrayUnion([Constants.uid + '_' + userName]),
      'groupId': groupName
    });

    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(Constants.uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupName])
    });
  }

  Future joinGrp(String userName, var grpName) async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(Constants.uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef =
        FirebaseFirestore.instance.collection('groups').doc(grpName);

    List<dynamic> groups = await (userDocSnapshot.data() as Map)['groups'];
    if (groups.length != 0) {
      if (groups.contains(grpName) == true) {
        //print('hey');
        await userDocRef.update({
          'groups': FieldValue.arrayUnion([grpName])
        });

        await groupDocRef.update({
          'members': FieldValue.arrayUnion([Constants.uid + '_' + userName])
        });
      } else {
        //print('nay');
        await userDocRef.update({
          'groups': FieldValue.arrayUnion([grpName])
        });

        await groupDocRef.update({
          'members': FieldValue.arrayUnion([Constants.uid + '_' + userName])
        });
      }
    } else {
      //print('nay');
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([grpName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([Constants.uid + '_' + userName])
      });
    }
  }

  // toggling the user group join
  // Future togglingGroupJoin(
  //     String groupId, String groupName, String userName) async {
  //   DocumentReference userDocRef =
  //       FirebaseFirestore.instance.collection('users').doc(Constants.uid);
  //   DocumentSnapshot userDocSnapshot = await userDocRef.get();

  //   DocumentReference groupDocRef =
  //       FirebaseFirestore.instance.collection('groups').doc(groupId);

  //   List<dynamic> groups = await userDocSnapshot.data()['groups'];

  //   if (groups.contains(groupId + '_' + groupName)) {
  //     //print('hey');
  //     await userDocRef.update({
  //       'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
  //     });

  //     await groupDocRef.update({
  //       'members': FieldValue.arrayRemove([Constants.uid + '_' + userName])
  //     });
  //  }
  // }

  // has user joined the flight group
  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(Constants.uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await (userDocSnapshot.data() as Map)['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    } else {
      //print('ne');
      return false;
    }
  }

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  // get user flight groups
  getUserGroups() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc("${Constants.uid}")
        .snapshots();
  }

  // send Flight chat message
  sendMessage(String groupId, chatMessageData) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(chatMessageData);
    FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // get chats of a particular group
  getChats(String groupId) async {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  // search groups: Future
  searchByName(String groupName) {
    return FirebaseFirestore.instance
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .get();
  }

  // create City group
  Future createCityGroup(String userName, String groupName) async {
    await FirebaseFirestore.instance
        .collection('City groups')
        .doc(groupName)
        .set({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await FirebaseFirestore.instance
        .collection('City groups')
        .doc(groupName)
        .update({
      'members': FieldValue.arrayUnion([Constants.uid + '_' + userName]),
      'groupId': groupName
    });

    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(Constants.uid);
    return await userDocRef.update({
      'City groups': FieldValue.arrayUnion([groupName])
    });
  }

  // Join City group
  Future joinCityGrp(String userName, String grpName) async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(Constants.uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef =
        FirebaseFirestore.instance.collection('City groups').doc(grpName);

    List<dynamic> groups = await (userDocSnapshot.data() as Map)['groups'];

    if (groups.contains(grpName)) {
      //print('hey');
      await userDocRef.update({
        'City groups': FieldValue.arrayRemove([grpName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([Constants.uid + '_' + userName])
      });
    } else {
      //print('nay');
      await userDocRef.update({
        'City groups': FieldValue.arrayUnion([grpName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([Constants.uid + '_' + userName])
      });
    }
  }

  // Dont join user again in grp if he is already present
  Future<bool> isUserJoinedinCityGrp(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(Constants.uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await (userDocSnapshot.data() as Map)['City groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    } else {
      //print('ne');
      return false;
    }
  }

  // get user City groups
  getUserCityGroups() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc("${Constants.uid}")
        .snapshots();
  }

  // send City message
  sendMessageCity(String groupId, chatMessageData) {
    FirebaseFirestore.instance
        .collection('City groups')
        .doc(groupId)
        .collection('messages')
        .add(chatMessageData);
    FirebaseFirestore.instance.collection('City groups').doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // get chats of a particular City group
  getCityChats(String groupId) async {
    return FirebaseFirestore.instance
        .collection('City groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
}
