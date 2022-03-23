import 'dart:html';
import 'dart:async';

import 'package:phoenix_wings/src/phoenix_connection.dart';

/// PhoenixHtmlConnection handles the creation and use
/// of the underlying websocket connection on browser platforms.
class PhoenixHtmlConnection extends PhoenixConnection {
  final String _endpoint;

  late WebSocket _conn;
  late Future _opened;

  @override
  bool get isConnected => _conn.readyState == WebSocket.OPEN;
  @override
  int get readyState => _conn.readyState;

  static PhoenixConnection provider(String endpoint) {
    return PhoenixHtmlConnection(endpoint);
  }

  PhoenixHtmlConnection(this._endpoint) {
    _conn = WebSocket(_endpoint);
    _opened = _conn.onOpen.first;
  }

  // waitForConnection is idempotent, it can be called many
  // times before or after the connection is established
  @override
  Future<PhoenixConnection> waitForConnection() async {
    if (_conn.readyState == WebSocket.OPEN) {
      return this;
    }

    await _opened;
    return this;
  }

  @override
  void close([int? code, String? reason]) => _conn.close(code, reason);
  @override
  void send(String data) => _conn.sendString(data);

  @override
  void onClose(void Function() callback) => _conn.onClose.listen((e) {
        callback();
      });
  @override
  void onError(void callback(err)) => _conn.onError.listen((e) {
        callback(e);
      });
  @override
  void onMessage(void Function(String m) callback) =>
      _conn.onMessage.listen((e) {
        callback(_messageToString(e));
      });

  String _messageToString(MessageEvent e) {
    // TODO: what are the types here?
    return e.data as String;
  }
}
