# Reminders

This is a simple Flutter plugin to provider, read, write, edit and delete access to Apple Reminders on ios and MacOS.

## API

When the `reminders` class is instantiated it requests permission to access the users reminders. If permission has not yet been given a popup will appear asking for permission. Success or failure can be determined:

`Future<bool> requestPermission()`
This will prompt a system alert dialog with the text you provided from 'NSRemindersUsageDescription'. Returns true if user accepted prompt (or has already accepted), or false (or if it has already been declined previously).

`Future<bool> hasAccess()`

Apple Calendars has a default Reminders List it uses if no list is specified when creating a new reminder. The list ID can be determined:

`Future<String?> getDefaultListId()`

Apple Reminders support multiple lists of reminders. A complete list of lists can be determined:

`Future<RemList?> getDefaultList()`

Apple Reminders support multiple lists of reminders. A complete list of lists can be determined:

`Future<List<RemList>> getAllLists()`

Get all the reminders in a List by passing the `RemList.id` to:

`Future<List<Reminder>?> getReminders([String? id])`

Attributes of a Reminder can be changed or a new Reminder can be created and then saved. Changes induce, but are not limited to, marking Reminders complete or not and setting due dates:

`Future<Reminder> saveReminder(Reminder reminder)`

Delete a reminder by passing the `Reminder.id` to:
Future<String?> deleteReminder(String id) async`

## iOS integration

Add the following key/value pair to your Info.plist

iOS 17 or BELOW:
>
>    `<key>NSRemindersUsageDescription</key>`
>
>    `<string>INSERT_REASON_HERE</string>`

iOS 17 or ABOVE:
>    `<key>NSRemindersFullAccessUsageDescription</key>`
>
>    `<string>INSERT_REASON_HERE</string>`

For now (iOS 17), you do not need the second entry but it is recommended you do so as 'NSRemindersUsageDescription' is deprecated and won't be supported in iOS 18+ which means your app will not be able to request permission!

## MacOS integration

Add the following to `macos/Runner/DebugProfile.entitlements` and 'macos/Runner/Release.entitlements'

>
>   `<key>com.apple.security.personal-information.calendars</key>`
>   `<true/>`
>

### Android, Web, Windows & Linux integration

As this plugin only supports Apple Reminders, there is no Android, Web, Windows, or Linux integration.
