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
            if ZLunch[cycleDay] == 3 && (block == 5 || block == 6){
                return "e"
            } else {
                switch block {
                case 0:
                    return "Homeroom"
                case 1:
                    return rooms[getDay()]![0]
                case 2:
                    return rooms[getDay()]![1]
                case 3:
                    return "e"
                case 4:
                    return rooms[getDay()]![2]
                case 5:
                    if getLunch(day: cycleDay, z: 1) == "Lunch"{
                        return "e"
                    } else {
                        return rooms[getDay()]![3]
                    }
                case 6:
                    if getLunch(day: cycleDay, z: 2) == "Lunch"{
                        return "e"
                    } else {
                        return rooms[getDay()]![3]
                    }
                case 7:
                    return rooms[getDay()]![4]
                case 8:
                    return "e"
                case 9:
                    return "e"
                default:
                    return "e"
                }
            }
        } else {
            return "e"
        }
        
    }
    func getTime(label: String) -> String{
        if label.starts(with: "Q"){
            if label.starts(with: "Q1"){
                switch block{
                case 1:
                    return "08:40 - 08:55"
                case 2:
                    return "09:45 - 11:00"
                case 3:
                    return "10:45 - 10:54"
                case 4:
                    return "11:20 - 11:35"
                case 5:
                    return "12:25 - 12:35"
                case 6:
                    return "12:50 - 13:00"
                case 7:
                    return "13:35 - 13:50"
                case 8:
                    return "14:40 - 14:45"
                default:
                    return "e"
                }
            } else if label.starts(with: "Q2"){
                switch block{
                case 1:
                    return "08:55 - 09:10"
                case 2:
                    return "11:00 - 11:15"
                case 3:
                    return "10:54 - 11:03"
                case 4:
                    return "11:35 - 11:50"
                case 5:
                    return "12:35 - 12:45"
                case 6:
                    return "13:00 - 13:10"
                case 7:
                    return "13:50 - 14:05"
                case 8:
                    return "14:45 - 14:50"
                default:
                    return "e"
                }
            } else if label.starts(with: "Q3"){
                switch block{
                case 1:
                    return "09:10 - 09:25"
                case 2:
                    return "11:15 - 11:30"
                case 3:
                    return "11:03 - 11:12"
                case 4:
                    return "11:50 - 12:05"
                case 5:
                    return "12:45 - 12:55"
                case 6:
                    return "13:10 - 13:20"
                case 7:
                    return "14:05 - 14:20"
                case 8:
                    return "14:50 - 14:55"
                default:
                    return "e"
                }
            } else if label.starts(with: "Q4"){
                switch block{
                case 1:
                    return "09:25 - 09:40"
                case 2:
                    return "11:30 - 11:45"
                case 3:
                    return "11:12 - 11:20"
                case 4:
                    return "12:05 - 12:20"
                case 5:
                    return "12:55 - 13:05"
                case 6:
                    return "13:20 - 13:30"
                case 7:
                    return "14:20 - 14:35"
                case 8:
                    return "14:55 - 15:00"
                default:
                    return "e"
                }
            }
            return "e"
        } else if ZLunch[cycleDay] == 3 && (block == 5 || block == 6){
            return "12:25 - 13:30"
        } else {
            switch block {
            case 0:
                return "08:30 - 08:35"
            case 1:
                return "08:40 - 09:40"
            case 2:
                return "09:45 - 10:45"
            case 3:
                return "10:45 - 11:20"
            case 4:
                return "11:20 - 12:20"
            case 5:
                return "12:25 - 13:05"
            case 6:
                return "12:50 - 13:30"
            case 7:
                return "13:35 - 14:35"
            case 8:
                return "14:40 - 15:00"
            case 9:
                return "15:30 - 17:00"
            default:
                return "e"
            }
        }
    }
    
    func meetingOrAssessment() -> String{
        let month = time.month!
        let day = time.day!
        if ZLunch[cycleDay] == 3 && (block == 5 || block == 6){
            return "Meeting"
        } else {
            switch block {
            case 0:
                return "Meeting"
            case 1:
                return (classes[dateToCycleDay[month-1][day]!]![0].starts(with: "Free") || classes[dateToCycleDay[month-1][day]!]![0].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
            case 2:
                return (classes[dateToCycleDay[month-1][day]!]![1].starts(with: "Free") || classes[dateToCycleDay[month-1][day]!]![1].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
            case 3:
                return "Meeting"
            case 4:
                return (classes[dateToCycleDay[month-1][day]!]![2].starts(with: "Free") || classes[dateToCycleDay[month-1][day]!]![2].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
            case 5:
                if getLunch(day: cycleDay, z: 1) == "Lunch"{
                    return "Meeting"
                } else {
                    return (classes[dateToCycleDay[month-1][day]!]![3].starts(with: "Free") || classes[dateToCycleDay[month-1][day]!]![3].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
                }
            case 6:
                if getLunch(day: cycleDay, z: 2) == "Lunch"{
                    return "Meeting"
                } else {
                    return (classes[dateToCycleDay[month-1][day]!]![3].starts(with: "Free") || classes[dateToCycleDay[month-1][day]!]![3].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
                }
            case 7:
                return (classes[dateToCycleDay[month-1][day]!]![4].starts(with: "Free") || classes[dateToCycleDay[month-1][day]!]![4].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
            case 8:
                return "Meeting"
            default:
                return "e"
            }
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
            return "Advisory"
        case 1:
            return blocks[getDay()]![0] + " Block"
        case 2:
            return blocks[getDay()]![1] + " Block"
        case 3:
            switch weekday {
            case 1:
                return "None"
            case 2:
                return "/nCommunity Meeting"
            case 3:
                return "Clubs"
            case 4:
                return "Class Meeting"
            case 5:
                return "Advisory"
            case 6:
                return "Clubs"
            case 7:
                return "None"
            default:
                return "error"
            }
        case 4:
            return blocks[getDay()]![2] + " Block"
        case 5:
            if getLunch(day: cycleDay, z: 1) == "Lunch"{
                return "Lunch (Z1)"
            } else {
                return "Z1"
            }
        case 6:
            if getLunch(day: cycleDay, z: 2) == "Lunch"{
                return "Lunch (Z2)"
            } else {
                return "Z2"
            }
        case 7:
            return blocks[getDay()]![4] + " Block"
        case 8:
            return "Office Hours"
        case 9:
            return sports[getDay()]
        default:
            return "e"
        }
    }
    
    func isEqual(_ other: blockEvent) -> Bool {
        return self.toString() == other.toString()
    }
}
var eventsList: [[Int: [blockEvent]]] = [
    // January 2023
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
    // February 2023
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[]],
    // March 2023
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
    // April 2023
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
    // May 2023
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
    // June 2023
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
    // July 2022
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
    // August 2022
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
    // September 2022
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
    // October 2022
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
    // November 2022
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
    // December 2022
    [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]]
]


class EventsListObs: ObservableObject {
    static var evList: [[Int: [blockEvent]]] = [
        // January 2023
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
        // February 2023
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[]],
        // March 2023
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
        // April 2023
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
        // May 2023
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
        // June 2023
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
        // July 2022
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
        // August 2022
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
        // September 2022
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
        // October 2022
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]],
        // November 2022
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[]],
        // December 2022
        [1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[], 12:[], 13:[], 14:[], 15:[], 16:[], 17:[], 18:[], 19:[], 20:[], 21:[], 22:[], 23:[], 24:[], 25:[], 26:[], 27:[], 28:[], 29:[], 30:[], 31:[]]
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
