import 'package:am_debug/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  Future<User> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  getUser(String phone) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('PhoneNo cases', arrayContains: phone)
        .get();
  }

  uploadUserInfo(String uid, Map userInfo) async {
    print('$uid');
    await FirebaseFirestore.instance.collection("users").doc(uid).set(userInfo);
  }

    uploadTravelInfo(String uid, Map userInfo, String from, String to) async {
    print('$uid');
    await FirebaseFirestore.instance.collection("users").doc(uid).collection("User Travel Info").doc("$from -> $to").set(userInfo);
  }

  // Future updateInfo(String uid, String date, String city) async {
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(uid)
  //       .update({
  //     "DOB": date,
  //     "city": city,
  //   }).catchError((error) {
  //     print(error);
  //   });
  // }

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
      };

      await DatabaseMethods().uploadUserInfo(uid, userInfoMap);
    }
  }

    Future<void> uploadTriptoDB(String date, String travellingFrom, String travellingTo,
      String bookingNo) async {

    if (Constants.uid != null) {
      Map<String, dynamic> tripInfoMap = {
        "Date": date,
        "Travelling from": travellingFrom.toString(),
        "Travelling to": travellingTo.toString(),
        "Booking No": bookingNo.toString(),
      };

      await DatabaseMethods().uploadTravelInfo(Constants.uid, tripInfoMap, travellingFrom, travellingTo);
    }
  }



  createChatroom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

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

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatRooms(String phone) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: phone)
        .snapshots();
  }
}
