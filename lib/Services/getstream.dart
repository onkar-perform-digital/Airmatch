import 'package:am_debug/helpers/constants.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class GetStream {
  connectUser(User user, String token) {
    Constants.client.connectUser(user, token);
  }

  // Group=== Channel
  // Watching channnel Creates grp if not present and the allows the person to watch the grp, else if grp allready present then allows user to watch grp
  creatingWatchingChannel(String fname, String grpname) async {
    final channel = Constants.client.channel(
      "messaging",
      id: grpname.toString(),
      extraData: {
        "name": grpname.toString(),
        "members": [Constants.phoneno.toString()],
      },
    );
    channel.watch();
    return channel;
  }
}
