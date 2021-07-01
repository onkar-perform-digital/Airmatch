import 'package:am_debug/Services/getstream.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatefulWidget {
  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {


  @override
  Widget build(BuildContext context) {

    return StreamChannel(
      // Get current channel and connect it
      channel: Constants.channel,
      child: StreamChat(
        // Initiate stream chat 
        client: Constants.client,
        child: Scaffold(
          // Currently keeping stock StreamChat UI
          appBar: ChannelHeader(),
          body: Column(
            children: [
              Expanded(
                child: MessageListView(),
              ),
              MessageInput(),
            ],
          ),
        ),
      ),
    );
  }
}
