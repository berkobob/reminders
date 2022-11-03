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

  Future<List<Reminder>?> getReminders([String? id]) async {
    return RemindersPlatform.instance.getReminders(id);
  }

  Future<Reminder> saveReminder(Reminder reminder) async {
    return RemindersPlatform.instance.saveReminder(reminder);
  }

  Future<String?> deleteReminder(String id) async {
    return RemindersPlatform.instance.deleteReminder(id);
  }
}
