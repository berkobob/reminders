import 'reminder.dart';
export 'reminder.dart';
import 'reminders_list.dart';
export 'reminders_list.dart';

import 'reminders_platform_interface.dart';

class Reminders {
  Future<String?> getPlatformVersion() {
    return RemindersPlatform.instance.getPlatformVersion();
  }

  Future<bool> hasAccess() async {
    return RemindersPlatform.instance.hasAccess();
  }

  Future<RemList?> getDefaultList() async {
    return RemindersPlatform.instance.getDefaultList();
  }

  Future<List<RemList>?> getAllLists() async {
    return RemindersPlatform.instance.getAllLists();
  }

  Future<List<Reminder>?> getRemindersInList(String id) async {
    return RemindersPlatform.instance.getRemindersInList(id);
  }

  Future<Reminder> createReminder(Reminder reminder) async {
    return RemindersPlatform.instance.createReminder(reminder);
  }

  Future<List<Reminder>?> getAllReminders() async {
    return RemindersPlatform.instance.getAllReminders();
  }

  Future<String?> deleteReminder(String id) async {
    return RemindersPlatform.instance.deleteReminder(id);
  }
}
