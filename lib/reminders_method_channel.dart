import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'reminders_platform_interface.dart';
import 'reminders_list.dart';
import 'reminder.dart';

/// An implementation of [RemindersPlatform] that uses method channels.
class MethodChannelReminders extends RemindersPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('reminders');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> hasAccess() async {
    final access = await methodChannel.invokeMethod('hasAccess');
    return access;
  }

  @override
  Future<RemList?> getDefaultList() async {
    final defaultList = await methodChannel.invokeMethod('getDefaultList');
    if (defaultList == null) return null;
    return RemList.fromJson(jsonDecode(defaultList));
  }

  @override
  Future<List<RemList>?> getAllLists() async {
    final lists = await methodChannel.invokeMethod('getAllLists');
    return jsonDecode(lists)
        .map<RemList>((list) => RemList.fromJson(list))
        .toList();
  }

  @override
  Future<List<Reminder>?> getReminders([String? id]) async {
    final reminders =
        await methodChannel.invokeMethod('getReminders', {'id': id});
    final result = jsonDecode(reminders)
        .map<Reminder>((reminder) => Reminder.fromJson(reminder))
        .toList();
    return (result);
  }

  @override
  Future<Reminder> saveReminder(Reminder reminder) async {
    reminder.id = await methodChannel
        .invokeMethod('saveReminder', {'reminder': reminder.toJson()});
    return reminder;
  }

  @override
  Future<String?> deleteReminder(String? id) async {
    return await methodChannel.invokeMethod('deleteReminder', {'id': id});
  }
}
