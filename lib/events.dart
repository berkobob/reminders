import 'calendar.dart';
import 'event.dart';
import 'reminders_platform_interface.dart';

class Events {
  Future<bool> hasEventsAccess() async {
    return RemindersPlatform.events.hasEventsAccess();
  }

  Future<String?> requestAccess() async {
    return RemindersPlatform.events.requestAccess();
  }

  Future<String?> getDefaultCalendar() async {
    return RemindersPlatform.events.getDefaultCalendar();
  }

  Future<List<Calendar>?> getAllCalendars() async {
    return RemindersPlatform.events.getAllCalendars();
  }

  Future<List<Event>?> getEvents() async {
    return RemindersPlatform.events.getEvents();
  }
}
