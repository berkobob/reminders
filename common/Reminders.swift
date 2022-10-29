import EventKit

class Reminders {
    let eventStore: EKEventStore = EKEventStore()
    var hasAccess: Bool = true
    let defaultList: EKCalendar?

    init() {
        defaultList = eventStore.defaultCalendarForNewReminders()
        eventStore.requestAccess(to: EKEntityType.reminder, completion: {(granted, error) in 
            self.hasAccess = granted ? true : false
            })
    }

    func getDefaultList() -> String? {
        if let defaultList = defaultList { return List(list: defaultList).toJson() }
        return nil
    }

    func getAllLists() -> String? {
        let lists = eventStore.calendars(for: .reminder)
        let jsonData = try? JSONEncoder().encode(lists.map { List(list: $0) })
        return String(data: jsonData ?? Data(), encoding: .utf8)
    }

    func getRemindersInList(_ id: String, _ completion: @escaping(String?) -> ()) {
        let calendar : [EKCalendar] = [eventStore.calendar(withIdentifier: id) ?? EKCalendar()]
        let predicate: NSPredicate? = eventStore.predicateForReminders(in: calendar)
        if let predicate = predicate {
            eventStore.fetchReminders(matching: predicate) { (_ reminders: [Any]?) -> Void in 
            let rems = reminders as? [EKReminder] ?? [EKReminder]()
            let result = rems.map { Reminder(reminder: $0) }
            let json = try? JSONEncoder().encode(result)
            completion(String(data: json ?? Data(), encoding: .utf8))      
            }
        }
    }
}

struct Reminder : Codable {
    let id: String
    let title: String
    let dueDate: DateComponents?
    let priority: Int 
    let isCompleted: Bool
    let url: String?
    let notes: String?

    init(reminder : EKReminder) {
        self.id = reminder.calendarItemIdentifier
        self.title = reminder.title
        self.dueDate = reminder.dueDateComponents
        self.priority = reminder.priority
        self.isCompleted = reminder.isCompleted
        self.url = reminder.url?.description
        self.notes = reminder.notes
    }

    func toJson() -> String? {
        let jsonData = try? JSONEncoder().encode(self)
        return String(data: jsonData ?? Data(), encoding: .utf8)
    }
}

struct List : Codable {
    let title: String
    let id: String

    init(list : EKCalendar) {
        self.title = list.title
        self.id = list.calendarIdentifier
    }

    func toJson() -> String? {
        let jsonData = try? JSONEncoder().encode(self)
        return String(data: jsonData ?? Data(), encoding: .utf8)
    }
}
