import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:phoenix_wings/src/phoenix_connection.dart';

/// PhoenixIoConnection handles the creation and use
/// of the underlying websocket connection on browser platforms.
class PhoenixIoConnection extends PhoenixConnection {
  Future<WebSocket>? _connFuture;
  WebSocket? _conn;
  final String _endpoint;

  // Use completer for close event because:
  //  * onDone of WebSocket doesn't fire consistently :(
  //  * this enables setting onClose/onDone/onError separately
  Completer _closed = Completer();

  @override
  bool get isConnected => _conn?.readyState == WebSocket.open;
  @override
  int get readyState => _conn?.readyState ?? WebSocket.closed;

  static PhoenixConnection provider(String endpoint) {
    return PhoenixIoConnection(endpoint);
  }

  PhoenixIoConnection(this._endpoint);

  // waitForConnection is idempotent, it can be called many
  // times before or after the connection is established
  @override
  Future<PhoenixConnection> waitForConnection() async {
    _connFuture ??= WebSocket.connect(_endpoint);
    _conn = await _connFuture;

    return this;
  }

  @override
  void close([int? code, String? reason]) => _conn?.close(code, reason);

  @override
  void send(String data) {
    if (isConnected) {
      try {
        _conn!.add(data);
      } catch (e) {
        log((e as dynamic).message);
      }
    }
  }

  @override
  void onClose(void Function() callback) {
    _closed.future.then((e) {
      callback();
    });
  }

  @override
  void onError(void callback(dynamic)) {
    _conn!.handleError(callback);
    _conn!.done.catchError(callback);
  }

  String? _messageToString(dynamic e) {
    // TODO: types are String or List<int>
    return e as String?;
  }

  @override
  void onMessage(void Function(String? m) callback) {
    _conn!.listen((e) {
      callback(_messageToString(e));
    }, onDone: () {
      _closed.complete();
    });
  }
}
