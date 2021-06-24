import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CityChatPage extends StatefulWidget {

  final String groupId;
  final String userName;
  final String groupName;

  CityChatPage({
    this.groupId,
    this.userName,
    this.groupName
  });

  @override
  _CityChatPageState createState() => _CityChatPageState();
}

class _CityChatPageState extends State<CityChatPage> {
  
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

      DatabaseMethods().sendMessageCity(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseMethods().getCityChats(widget.groupId).then((val) {
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
        centerTitle: true,
        backgroundColor: Color(Constants.blueClr),
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: [
            _chatMessages(),
            // Container(),
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
                          color: Color(0xFF000000)
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
                          color: Colors.blueAccent,
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
        top: 4,
        bottom: 4,
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
          color: sentByMe ? Color(0xFF358EE8) : Color(0xFFF2F2F2),
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