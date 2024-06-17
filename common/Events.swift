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
        let predicate: NSPredicate = eventStore.predicateForEvents(withStart: Date.distantPast, end: Date.distantFuture, calendars: [defaultCalendar!])
        var rawEvents: [EKEvent]? = nil
        rawEvents = eventStore.events(matching: predicate);
        let events = rawEvents ?? [EKEvent]()
        let results = events.map { Event(event: $0) }
        let json = try? JSONEncoder().encode(results)
        completion(String(data: json ?? Data(), encoding: .utf8))
        // if let predicate = predicate {
        //     eventStore.events(matching: predicate) { (_ events: [Any]?) -> Void in
        //         let e = events as? [EKEvent] ?? [EKEvent]()
        //         let result = e.map { Event(event: $0) }
        //         let json = try? JSONEncoder().encode(result)
        //         completion(String(data: json ?? Data(), encoding: .utf8))
        //     }
        // }
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
    let startDate: Date
    let endDate: Date
    let location: String?
    let isAllDay: Bool
    let notes: String?

    init(event : EKEvent) {
        self.id = event.calendarItemIdentifier
        self.title = event.title
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.location = event.location
        self.isAllDay = event.isAllDay
        self.notes = event.notes
    }

    func toJson() -> String? {
        let jsonData = try? JSONEncoder().encode(self)
        return String(data: jsonData ?? Data(), encoding: .utf8)
    }

}
