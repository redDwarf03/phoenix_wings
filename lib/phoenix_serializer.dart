import 'package:phoenix_wings/phoenix_message.dart';

class PhoenixSerializer {
  static String encode(PhoenixMessage msg) {
    return msg.toJSON();
  }

  static PhoenixMessage decode(String rawPayload) {
    return PhoenixMessage.decode(rawPayload);
  }
}
