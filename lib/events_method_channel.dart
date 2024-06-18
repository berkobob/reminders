import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'event.dart';
import 'reminders_platform_interface.dart';
import 'calendar.dart';

/// An implementation of [RemindersPlatform] that uses method channels.
class MethodChannelEvents extends RemindersPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('reminders');

  @override
  Future<bool> hasEventsAccess() async {
    return await methodChannel.invokeMethod("hasEventsAccess");
  }

  @override
  Future<String?> requestAccess() async {
    return await methodChannel.invokeMethod("requestAccess");
  }

  @override
  Future<String?> getDefaultCalendar() async {
    final defaultCalendar =
        await methodChannel.invokeMethod('getDefaultCalendar');
    if (defaultCalendar == null) return null;
    // return jsonDecode(defaultCalendar);
    return defaultCalendar;
  }

  @override
  Future<List<Calendar>?> getAllCalendars() async {
    final calendars = await methodChannel.invokeMethod('getAllCalendars');
    if (calendars == null) return null;
    final result = jsonDecode(calendars);
    return result
        .map<Calendar>((calendar) => Calendar.fromJson(calendar))
        .toList();
  }

  @override
  Future<List<Event>?> getEvents() async {
    final events = await methodChannel.invokeMethod('getEvents');
    if (events == null) return null;
    final json = jsonDecode(events);
    return json.map<Event>((json) => Event.fromJson(json)).toList();
  }
}
