import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'calendar.dart';
import 'event.dart';
import 'events_method_channel.dart';
import 'reminder.dart';
import 'reminders_list.dart';
import 'reminders_method_channel.dart';

abstract class RemindersPlatform extends PlatformInterface {
  /// Constructs a RemindersPlatform.
  RemindersPlatform() : super(token: _token);

  static final Object _token = Object();

  static RemindersPlatform _reminders = MethodChannelReminders();
  static RemindersPlatform _events = MethodChannelEvents();

  /// The default instance of [RemindersPlatform] to use.
  ///
  /// Defaults to [MethodChannelReminders].
  static RemindersPlatform get reminders => _reminders;
  static RemindersPlatform get events => _events;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RemindersPlatform] when
  /// they register themselves.
  static set reminders(RemindersPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _reminders = instance;
  }

  static set events(RemindersPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _events = instance;
  }

  Future<String?> getPlatformVersion() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> hasAccess() async {
    throw UnimplementedError('hasAccess() has not been implemented.');
  }

  Future<bool> requestPermission() async {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  Future<String> getDefaultListId() async {
    throw UnimplementedError('getDefaultListId() has not been implemented.');
  }

  Future<RemList?> getDefaultList() async {
    throw UnimplementedError('getDefaultList() has not been implemented.');
  }

  Future<List<RemList>> getAllLists() async {
    throw UnimplementedError('getAllLists() has not been implemented.');
  }

  Future<List<Reminder>?> getReminders([String? id]) async {
    throw UnimplementedError('getReminders(String?) has not been implemented');
  }

  Future<Reminder> saveReminder(Reminder reminder) async {
    throw UnimplementedError('saveReminder(Reminder) has not been implemented');
  }

  Future<RemList> saveRemList(RemList remList) async {
    throw UnimplementedError('saveRemList(remList) has not been implemented');
  }

  Future<String?> deleteReminder(String? id) async {
    throw UnimplementedError('deleteReminder(String) has not been implemented');
  }

  Future<String?> requestAccess() async {
    throw UnimplementedError('requestAccess() has not been implemented');
  }

  Future<bool> hasEventsAccess() async {
    throw UnimplementedError('hasEventsAccess() has not been implemented');
  }

  Future<String?> getDefaultCalendar() async {
    throw UnimplementedError('getDefaultCalendar has not been implemented');
  }

  Future<List<Calendar>?> getAllCalendars() async {
    throw UnimplementedError('getAllCalendars has not been implemented');
  }

  Future<List<Event>?> getEvents([String? id]) async {
    throw UnimplementedError('getEvents has not been implemented');
  }
}
