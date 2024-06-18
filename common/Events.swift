import EventKit

class Events {
    let eventStore: EKEventStore = EKEventStore()
    let defaultCalendar: EKCalendar?

    init() {
        defaultCalendar = eventStore.defaultCalendarForNewEvents
        print(EKEventStore.authorizationStatus(for: .event))
        requestAccess()
    }

     func requestAccess() {
        let status = EKEventStore.authorizationStatus(for: .event)
        if status == .authorized {
            print("Access is already granted.")
        } else {
            print(status.rawValue)
            if #available(macOS 14.0, *) {
                if #available(iOS 17.0, *) {
                    eventStore.requestFullAccessToEvents { success, error in
                        if success && error == nil {
                            print("Access has been granted.")
                        } else {
                            print(error as Any)
                            print("Access request failed with error: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
            } else {
                // Fallback on earlier versions
            }
        }
     }

    func getDefaultCalendar() -> String? {
        if let defaultCalendar = defaultCalendar { return Calendar(calendar: defaultCalendar).toJson() }
        return nil
    }

    func getAllCalendars() -> String? {
        let calendars = eventStore.calendars(for: .event)
        let jsonData = try? JSONEncoder().encode(calendars.map { Calendar(calendar: $0) })
        return String(data: jsonData ?? Data(), encoding: .utf8)
    }

    func getEvents(_ completion: @escaping(String?) -> ()) {
        let oneYearAgo = Date(timeIntervalSinceNow: -365*24*60*60)
        let oneYearAfter = Date(timeIntervalSinceNow: 365*24*60*60)
        let predicate: NSPredicate = eventStore.predicateForEvents(withStart: oneYearAgo, end: oneYearAfter, calendars: [defaultCalendar!])

        var events = [Event]()
        
        // Enumerate events matching the predicate
        eventStore.enumerateEvents(matching: predicate) { (ekEvent, stop) in
            let event = Event(event: ekEvent)
            events.append(event)
        }
        
        // Encode the result array to JSON
        if let jsonData = try? JSONEncoder().encode(events) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            completion(jsonString)
        } else {
            completion(nil)
        }
    }
}

struct Calendar : Codable {
    let title: String
    let id: String

    init(calendar : EKCalendar) {
        self.title = calendar.title
        self.id = calendar.calendarIdentifier
    }

    func toJson() -> String? {
        let jsonData = try? JSONEncoder().encode(self)
        return String(data: jsonData ?? Data(), encoding: .utf8)
    }
}

struct Event : Codable {
    let id: String
    let title: String
    let startDate: String
    let endDate: String
    let location: String?
    let isAllDay: Bool
    let notes: String?

    init(event : EKEvent) {
        self.id = event.calendarItemIdentifier
        self.title = event.title
        self.startDate = event.startDate.description
        self.endDate = event.endDate.description
        self.location = event.location
        self.isAllDay = event.isAllDay
        self.notes = event.notes
    }

    func toJson() -> String? {
        let jsonData = try? JSONEncoder().encode(self)
        return String(data: jsonData ?? Data(), encoding: .utf8)
    }

}
