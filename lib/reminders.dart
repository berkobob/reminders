import 'package:reminders/reminders_list.dart';
export 'package:reminders/reminders_list.dart';

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

  Future<List?> getRemindersInList(String id) async {
    return RemindersPlatform.instance.getRemindersInList(id);
  }

  Future<String?> createReminder(Map<String, dynamic> reminder) async {
    return RemindersPlatform.instance.createReminder(reminder);
  }
}
