import 'package:flutter_test/flutter_test.dart';
import 'package:reminders/reminders.dart';
import 'package:reminders/reminders_platform_interface.dart';
import 'package:reminders/reminders_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRemindersPlatform
    with MockPlatformInterfaceMixin
    implements RemindersPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> hasAccess() {
    // TODO: implement hasAccess
    throw UnimplementedError();
  }
}

void main() {
  final RemindersPlatform initialPlatform = RemindersPlatform.instance;

  test('$MethodChannelReminders is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelReminders>());
  });

  test('getPlatformVersion', () async {
    Reminders remindersPlugin = Reminders();
    MockRemindersPlatform fakePlatform = MockRemindersPlatform();
    RemindersPlatform.instance = fakePlatform;

    expect(await remindersPlugin.getPlatformVersion(), '42');
  });
}
