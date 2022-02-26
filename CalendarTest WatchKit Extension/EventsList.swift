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
//func setId(ev: blockEvent, idd: String) {
//    ev.id = idd
//}
class blockEvent {
//    var num = 0 //event 1, 2, 3?
    var block = 0 //
    var time = DateComponents(calendar: Calendar.current, month: 1, day: 1)
    var id = "000000" //MM DD B
    var label = "New "
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
    
    func meetingOrAssessment() -> String{
        let cal = Calendar.current
        let date = cal.date(from: time)!
        let weekday = cal.component(.weekday, from: date)
        switch block {
        case 0:
            return classes[weekday]![0].starts(with: "Free") ? "Meeting" : "Assessment"
        case 1:
            return weekday == 3 || weekday == 5 ? "Meeting" : "Event"
        case 2:
            return classes[weekday]![1].starts(with: "Free") ? "Meeting" : "Assessment"
        case 3:
            return classes[weekday]![2].starts(with: "Free") ? "Meeting" : "Assessment"
        case 4:
            return "Meeting"
        case 5:
            return classes[weekday]![3].starts(with: "Free") ? "Meeting" : "Assessment"
        case 6:
            return classes[weekday]![4].starts(with: "Free") ? "Meeting" : "Assessment"
        default:
            return "e"
        }
    }
    
    func getPeriod() -> String {
        switch block {
        case 0:
            return blocks[getDay()]![0] + " Block"
        case 1:
            return "Break/Clubs"
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
        default:
            return "e"
        }
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
