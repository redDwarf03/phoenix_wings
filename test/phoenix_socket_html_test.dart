@TestOn("browser")

import 'package:phoenix_wings/src/phoenix_html_connection.dart';
import 'package:test/test.dart';

import 'package:phoenix_wings/phoenix_wings.dart';

import 'phoenix_socket_tests.dart';

PhoenixSocket makeSocket(String e, PhoenixSocketOptions? so) {
  return PhoenixSocket(e,
      socketOptions: so, connectionProvider: PhoenixHtmlConnection.provider);
}

void main() {
  testPhoenixSocket(makeSocket);
}
