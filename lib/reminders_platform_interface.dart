import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'reminder.dart';
import 'reminders_list.dart';
import 'reminders_method_channel.dart';

abstract class RemindersPlatform extends PlatformInterface {
  /// Constructs a RemindersPlatform.
  RemindersPlatform() : super(token: _token);

  static final Object _token = Object();

  static RemindersPlatform _instance = MethodChannelReminders();

  /// The default instance of [RemindersPlatform] to use.
  ///
  /// Defaults to [MethodChannelReminders].
  static RemindersPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RemindersPlatform] when
  /// they register themselves.
  static set instance(RemindersPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> hasAccess() {
    throw UnimplementedError('hasAccess() has not been implemented.');
  }

  Future<RemList?> getDefaultList() {
    throw UnimplementedError('getDefaultList() has not been implemented.');
  }

  Future<List<RemList>?> getAllLists() {
    throw UnimplementedError('getAllLists() has not been implemented.');
  }

  Future<List<Reminder>?> getRemindersInList(String id) {
    throw UnimplementedError(
        'getRemindersInList(String) has not been implemented');
  }

  Future<Reminder> createReminder(Reminder reminder) {
    throw UnimplementedError(
        'createReminder(Reminder) has not been implemented');
  }
}
