import 'dart:async';

typedef PhoenixConnection PhoenixConnectionProvider(String endpoint);

abstract class PhoenixConnection {
  static const CLOSE_NORMAL = 1000;

  bool get isConnected;
  int get readyState;

  Future<PhoenixConnection> waitForConnection();

  void close([int? code, String? reason]);
  void closeNormal([String? reason]) => close(CLOSE_NORMAL, reason);

  void send(String data);

  void onClose(void Function() callback);
  void onError(void Function(dynamic err) callback);
  void onMessage(void Function(String? message) callback);
}
