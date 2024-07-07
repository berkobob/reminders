import 'reminder.dart';
export 'reminder.dart';
import 'reminders_list.dart';
export 'reminders_list.dart';

import 'reminders_platform_interface.dart';

class Reminders {
  Future<String?> getPlatformVersion() {
    return RemindersPlatform.reminders.getPlatformVersion();
  }

  Future<bool> hasAccess() async {
    return RemindersPlatform.reminders.hasAccess();
  }

  Future<bool> requestPermission() async {
    return RemindersPlatform.reminders.requestPermission();
  }

  Future<String> getDefaultListId() async {
    return RemindersPlatform.reminders.getDefaultListId();
  }

  Future<RemList?> getDefaultList() async {
    return RemindersPlatform.reminders.getDefaultList();
  }

  Future<List<RemList>> getAllLists() async {
    return RemindersPlatform.reminders.getAllLists();
  }

  Future<List<Reminder>?> getReminders([String? id]) async {
    return RemindersPlatform.reminders.getReminders(id);
  }

  Future<Reminder> saveReminder(Reminder reminder) async {
    return RemindersPlatform.reminders.saveReminder(reminder);
  }

  Future<RemList> saveRemList(RemList remList) async {
    return RemindersPlatform.reminders.saveRemList(remList);
  }

  Future<String?> deleteReminder(String id) async {
    return RemindersPlatform.reminders.deleteReminder(id);
  }
}
