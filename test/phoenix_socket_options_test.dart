@TestOn("vm")

import 'package:test/test.dart';
import 'package:phoenix_wings/src/phoenix_socket_options.dart';

void main() {
  test("Can create socket options with default values", () {
    final options = PhoenixSocketOptions();
    expect(options.timeout, 10000);
    expect(options.heartbeatIntervalMs, 30000);
    expect(options.reconnectAfterMs, null);
    expect(options.params, {"vsn": "2.0.0"});
  });

  test("Can create socket options with overridden timeout", () {
    final options = PhoenixSocketOptions(timeout: 99);
    expect(options.timeout, 99);
    expect(options.heartbeatIntervalMs, 30000);
    expect(options.reconnectAfterMs, null);
    expect(options.params, {"vsn": "2.0.0"});
  });

  test("Can create socket options with overridden heartbeatIntervalMs", () {
    final options = PhoenixSocketOptions(heartbeatIntervalMs: 99);
    expect(options.timeout, 10000);
    expect(options.heartbeatIntervalMs, 99);
    expect(options.reconnectAfterMs, null);
    expect(options.params, {"vsn": "2.0.0"});
  });

  test("Cannot override socket options with vsn params", () {
    final options = PhoenixSocketOptions(params: {});
    expect(options.timeout, 10000);
    expect(options.heartbeatIntervalMs, 30000);
    expect(options.reconnectAfterMs, null);
    expect(options.params, {"vsn": "2.0.0"});
  });

  test("Can create socket options with overridden params", () {
    final options = PhoenixSocketOptions(params: {"token": "test"});
    expect(options.timeout, 10000);
    expect(options.heartbeatIntervalMs, 30000);
    expect(options.reconnectAfterMs, null);
    expect(options.params, {"token": "test", "vsn": "2.0.0"});
  });
}
