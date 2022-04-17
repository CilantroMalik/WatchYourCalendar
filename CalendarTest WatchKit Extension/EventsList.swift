//
//  EventsList.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 2/15/22.
//

import Foundation

//func hasEvent(dc: DateComponents, bl: Int) -> Bool{
//        return numEvents[bl][dc] == 0 ? false : true
//}

func makeId(block: Int, time: DateComponents, num: Int) -> String{
    return ((String(time.month!).count == 1 ? "0" + String(time.month!) : String(time.month!)) + (String(time.day!).count == 1 ? "0" + String(time.day!) : String(time.day!)) + String(block) + String(num))
}
class blockEvent: Equatable {
    static func == (lhs: blockEvent, rhs: blockEvent) -> Bool {
        return lhs.toString() == rhs.toString()
    }
    
    var block = 0 //
    var time = DateComponents(calendar: Calendar.current, month: 1, day: 1)
    var id = "000000" //MM DD B
    var label = "Test"
    var hasLabel = false
    var hasNotification = false
    let cal = Calendar.current
    
    init(_ blockNum: Int, _ timeDC: DateComponents, _ idStr: String, _ aLabel: String, _ hasLbl: Bool, _ hasNotif: Bool) {
        self.block = blockNum
        self.time = timeDC
        self.id = idStr
        self.label = aLabel
        self.hasLabel = hasLbl
        self.hasNotification = hasNotif
    }
    
    init(_ str: String) {
        let elements = str.split(separator: "|")
        self.block = Int(elements[0])!
        self.time = DateComponents(calendar: Calendar.current, month: Int(elements[1])!, day: Int(elements[2])!)
        self.id = String(elements[3])
        self.label = String(elements[4])
        self.hasLabel = Bool(String(elements[5]))!
        self.hasNotification = Bool(String(elements[6]))!
    }
    
    func toString() -> String {
        //   0     1    2  3    4      5            6
        // block|month|day|id|label|hasLabel|hasNotification
        return "\(block)|\(time.month!)|\(time.day!)|\(id)|\(label)|\(hasLabel)|\(hasNotification)"
    }
    
    func getDay() -> Int{
        return dateToCycleDay[time.month!-1][time.day!]!
    }
    
    func getRoom() -> String{
        if meetingOrAssessment() == "Assessment"{
            switch block {
            case 0:
                return rooms[getDay()]![0]
            case 1:
                return "e"
            case 2:
                return rooms[getDay()]![1]
            case 3:
                return rooms[getDay()]![2]
            case 4:
                return "e"
            case 5:
                return rooms[getDay()]![3]
            case 6:
                return rooms[getDay()]![4]
            case 9:
                return "e"
            default:
                return "e"
            }
        } else {
            return "e"
        }
        
    }
    func getTime() -> String{
        switch block {
        case 0:
            return "08:55 - 09:55"
        case 1:
            return "10:00 - 10:30"
        case 2:
            return "10:35 - 11:25"
        case 3:
            return "11:25 - 12:25"
        case 4:
            return "12:25 - 13:15"
        case 5:
            return "13:20 - 14:20"
        case 6:
            return "14:30 - 15:15"
        case 9:
            return "14:20 - 14:30"
        default:
            return "e"
        }
    }
    
    func meetingOrAssessment() -> String{
        let month = time.month!
        let day = time.day!
        switch block {
        case 0:
            return classes[dateToCycleDay[month-1][day]!]![0].starts(with: "Free") ? "Meeting" : "Assessment"
        case 1:
//            return weekday == 3 || weekday == 5 ? "Meeting" : "Event"
            return "Meeting"
        case 2:
            return classes[dateToCycleDay[month-1][day]!]![1].starts(with: "Free") ? "Meeting" : "Assessment"
        case 3:
            return classes[dateToCycleDay[month-1][day]!]![2].starts(with: "Free") ? "Meeting" : "Assessment"
        case 4:
            return "Meeting"
        case 5:
            return classes[dateToCycleDay[month-1][day]!]![3].starts(with: "Free") ? "Meeting" : "Assessment"
        case 6:
            return classes[dateToCycleDay[month-1][day]!]![4].starts(with: "Free") ? "Meeting" : "Assessment"
        case 9:
            return "Meeting"
        default:
            return "e"
        }
    }
    
    func getPeriod() -> String {
        var date = Date()
        let cal = Calendar.current
        if globalOffset != 0 {
            date = cal.date(byAdding: .day, value: globalOffset, to: date)!
        }
        let weekday = cal.component(.weekday, from: date)
        switch block {
        case 0:
            return blocks[getDay()]![0] + " Block"
        case 1:
            switch weekday {
            case 1:
                return "None"
            case 2:
                return "\nCommunity Meeting"
            case 3:
                return "Clubs"
            case 4:
                return "Advisory"
            case 5:
                return "Clubs"
            case 6:
                return "Class Meeting"
            case 7:
                return "None"
            default:
                return "error... lul"
            }
        case 2:
            return blocks[getDay()]![1] + " Block"
        case 3:
            return blocks[getDay()]![2] + " Block"
        case 4:
            return "Lunch"
        case 5:
            return blocks[getDay()]![3] + " Block"
        case 6:
            return blocks[getDay()]![4] + " Block"
        case 9:
            return "Break"
        default:
            return "e"
        }
    }
    
    func isEqual(_ other: blockEvent) -> Bool {
        return self.toString() == other.toString()
    }
}
var eventsList: [[Int: [blockEvent]]] = [
    // January
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
    // February
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[]],
    // March
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
    // April
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
    // May
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
    // June
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[]]
]


class EventsListObs: ObservableObject {
    static var evList: [[Int: [blockEvent]]] = [
        // January
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
        // February
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[]],
        // March
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
        // April
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
        // May
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
        // June
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[]]
    ]
    
    init() {
        
    }
    
    func addEvent(ev: blockEvent, month: Int, day: Int) {
        EventsListObs.evList[month][day]!.append(ev)
        objectWillChange.send()
    }
    
    func delEvent(ev: blockEvent) {
        EventsListObs.evList[ev.time.month!-1][ev.time.day!] = EventsListObs.evList[ev.time.month!-1][ev.time.day!]!.filter { !($0.isEqual(ev)) }
        objectWillChange.send()
    }
    
}
