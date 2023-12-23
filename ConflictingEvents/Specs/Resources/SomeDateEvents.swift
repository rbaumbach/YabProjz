import Foundation
@testable import ConflictingEvents

struct SpecEventDataSource {
    private static let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        return dateFormatter
    }()
    
    static func build() -> [DateEvents] {
        return [
            DateEvents(date: "11/06/1955",
                       events: [
                            Event(title: "Breakfast w/ George McFly",
                                  startDate: buildDate(dateString: "11/06/1955 8:00 AM"),
                                  startJSONDateString: "November 6, 1955 8:00 AM",
                                  startTimeOnlyString: "8:00 AM",
                                  startDateOnlyString: "11/06/1955",
                                  endDate: buildDate(dateString: "11/06/1955 9:00 AM"),
                                  endDateJSONString: "November 6, 1955 9:00 AM",
                                  endTimeOnlyString: "9:00 AM"),
                            
                            Event(title: "Hang Clocks w/ Doc Brown",
                                  startDate: buildDate(dateString: "11/06/1955 6:00 PM"),
                                  startJSONDateString: "November 6, 1955 6:00 PM",
                                  startTimeOnlyString: "6:00 PM",
                                  startDateOnlyString: "11/06/1955",
                                  endDate: buildDate(dateString: "11/06/1955 9:00 PM"),
                                  endDateJSONString: "November 6, 1955 9:00 PM",
                                  endTimeOnlyString: "9:00 PM")
                       ]),
            
            // This instance of DateEvents has two events that have conflicts
            
            DateEvents(date: "11/08/1955",
                       events: [
                            Event(title: "Dealing w/ Biff Tannen",
                                  startDate: buildDate(dateString: "11/08/1955 10:00 AM"),
                                  startJSONDateString: "November 8, 1955 10:00 AM",
                                  startTimeOnlyString: "10:00 AM",
                                  startDateOnlyString: "11/08/1955",
                                  endDate: buildDate(dateString: "11/08/1955 8:00 PM"),
                                  endDateJSONString: "November 8, 1955 8:00 PM",
                                  endTimeOnlyString: "8:00 PM"),
                            
                            Event(title: "Detention w/ Mr. Strickland",
                                  startDate: buildDate(dateString: "11/08/1955 3:00 PM"),
                                  startJSONDateString: "November 8, 1955 3:00 PM",
                                  startTimeOnlyString: "3:00 PM",
                                  startDateOnlyString: "11/08/1955",
                                  endDate: buildDate(dateString: "11/08/1955 5:00 PM"),
                                  endDateJSONString: "November 8, 1955 5:00 PM",
                                  endTimeOnlyString: "5:00 PM")
                       ]),
        ]
    }
    
    static func buildDate(dateString: String) -> Date {
        return dateFormatter.date(from: dateString)!
    }
}
