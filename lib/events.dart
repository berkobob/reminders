import 'calendar.dart';
import 'reminders_platform_interface.dart';

class Events {
  Future<String?> getDefaultCalendar() async {
    return RemindersPlatform.events.getDefaultCalendar();
  }

  Future<List<Calendar>?> getAllCalendars() async {
    return RemindersPlatform.events.getAllCalendars();
  }

  Future<String?> getEvents() async {
    return RemindersPlatform.events.getEvents();
  }
}
