import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reminders/reminders_method_channel.dart';

void main() {
  MethodChannelReminders platform = MethodChannelReminders();
  const MethodChannel channel = MethodChannel('reminders');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
