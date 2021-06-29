import 'package:am_debug/helpers/constants.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class GetStream {
  creatingWatchingChannel(String fname, String grpname) async {
    final channel = Constants.client.channel("messaging",  id: grpname.toString(),  
  extraData: {
    "name": grpname.toString(),  
    "members": [fname.toString()],  
  },  
  );
  await channel.watch();
  }
}