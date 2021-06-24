import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:am_debug/helpers/members_list.dart';

class ChatPage extends StatefulWidget {

  final String groupId;
  final String userName;
  final String groupName;

  ChatPage({
    this.groupId,
    this.userName,
    this.groupName
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget _chatMessages(){
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return MessageTile(
              message: snapshot.data.docs[index].data()["message"],
              sender: snapshot.data.docs[index].data()["sender"],
              sentByMe: widget.userName == snapshot.data.docs[index].data()["sender"],
            );
          }
        )
        :
        Container();
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseMethods().getChats(widget.groupId).then((val) {
      print(val);
      print(widget.groupId);
      setState(() {
        _chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(Constants.blueClr),
        elevation: 0.0,
        toolbarHeight: 85,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MembersList(grpname: widget.groupName)));
              },
              child: Icon(Icons.people)),
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height-200,
              child: _chatMessages()),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Color(0xFFF2F2F2),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                        ),
                      ),
                    ),

                    SizedBox(width: 12.0),

                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: Color(Constants.blueClr),
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



class MessageTile extends StatelessWidget {

  final String message;
  final String sender;
  final bool sentByMe;

  MessageTile({this.message, this.sender, this.sentByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: sentByMe ? 0 : 24,
        right: sentByMe ? 24 : 0),
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
          borderRadius: sentByMe ? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          )
          :
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)
          ),
          color: sentByMe ? Color(Constants.blueClr) : Color(0xFFF2F2F2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender.toUpperCase(), textAlign: TextAlign.start, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5)),
            SizedBox(height: 7.0),
            Text(message, textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Colors.purple)),
          ],
        ),
      ),
    );
  }
}