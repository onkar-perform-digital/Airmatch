import 'package:am_debug/Services/Database.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();

  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.docs[index].data()["message"],
                        snapshot.data.docs[index].data()["sendBy"] ==
                            Constants.phoneno);
                  })
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'sendBy': Constants.phoneno,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    }

    messageController.text = "";
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Theme.of(context).accentColor,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type your message here...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
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
                          Icons.send,
                          color: Colors.blueGrey[100],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 15, right: isSendByMe ? 15 : 0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isSendByMe
                  ? [
                      Colors.blueGrey[400],
                      Colors.blueGrey[100],
                    ]
                  : [
                      Colors.blueAccent[100],
                      Colors.blue[300],
                    ]),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(26),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
