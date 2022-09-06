//
//  MobileUtilities.swift
//  whatever
//
//  Created by Rohan Malik on 8/29/22.
//

import Foundation

var cancellable = Connectivity.shared.$data.sink() {
    EventsListObs().replaceList(newList: $0["eventsList"] as! [[Int: [blockEvent]]])
}

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

var globalOffset = 0

var dateToCycleDay: [[Int: Int]] = [
    // January 2023
    [1:0, 2:0, 3:5, 4:6, 5:1, 6:2, 7:0, 8:0, 9:3, 10:4, 11:5, 12:6, 13:1, 14:0, 15:0, 16:0, 17:2, 18:3, 19:4, 20:5, 21:0, 22:0, 23:6, 24:1, 25:2, 26:3, 27:4, 28:0, 29:0, 30:5, 31:6],
    //February 2023
    [1:1, 2:2, 3:3, 4:0, 5:0, 6:4, 7:5, 8:6, 9:1, 10:2, 11:0, 12:0, 13:3, 14:4, 15:5, 16:6, 17:0, 18:0, 19:0, 20:0, 21:1, 22:2, 23:3, 24:4, 25:0, 26:0, 27:5, 28:6],
    //March 2023
    [1:1, 2:2, 3:3, 4:0, 5:0, 6:4, 7:5, 8:6, 9:1, 10:2, 11:0, 12:0, 13:0, 14:0, 15:0, 16:0, 17:0, 18:0, 19:0, 20:0, 21:0, 22:0, 23:0, 24:0, 25:0, 26:0, 27:3, 28:4, 29:5, 30:6, 31:1],
    //April 2023
    [1:0, 2:0, 3:2, 4:3, 5:4, 6:5, 7:0, 8:0, 9:0, 10:6, 11:1, 12:2, 13:3, 14:4, 15:0, 16:0, 17:5, 18:6, 19:1, 20:2, 21:3, 22:0, 23:0, 24:4, 25:5, 26:6, 27:1, 28:2, 29:0, 30:0],
    //May 2023
    [1:3, 2:4, 3:5, 4:6, 5:1, 6:0, 7:0, 8:2, 9:3, 10:4, 11:5, 12:6, 13:0, 14:0, 15:1, 16:2, 17:3, 18:4, 19:5, 20:0, 21:0, 22:6, 23:1, 24:2, 25:3, 26:4, 27:0, 28:0, 29:0, 30:5, 31:6],
    // June 2023
    [1:1, 2:2, 3:0, 4:0, 5:3, 6:4, 7:0, 8:0, 9:0, 10:0, 11:0, 12:0, 13:0, 14:0, 15:0, 16:0, 17:0, 18:0, 19:0, 20:0, 21:0, 22:0, 23:0, 24:0, 25:0, 26:0, 27:0, 28:0, 29:0, 30:0, 31:0],
    //July
    [1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0, 10:0, 11:0, 12:0, 13:0, 14:0, 15:0, 16:0, 17:0, 18:0, 19:0, 20:0, 21:0, 22:0, 23:0, 24:0, 25:0, 26:0, 27:0, 28:0, 29:0, 30:0, 31:0],
    //August
    [1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0, 10:0, 11:0, 12:0, 13:0, 14:0, 15:0, 16:0, 17:0, 18:0, 19:0, 20:0, 21:0, 22:0, 23:0, 24:0, 25:0, 26:0, 27:0, 28:0, 29:0, 30:0, 31:0],
    //September 2022
    [1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:1, 10:0, 11:0, 12:2, 13:3, 14:4, 15:5, 16:6, 17:0, 18:0, 19:1, 20:2, 21:3, 22:4, 23:5, 24:0, 25:0, 26:0, 27:6, 28:1, 29:2, 30:3],
    //October 2022
    [1:0, 2:0, 3:4, 4:5, 5:0, 6:6, 7:1, 8:0, 9:0, 10:0, 11:2, 12:3, 13:4, 14:5, 15:0, 16:0, 17:6, 18:1, 19:2, 20:3, 21:4, 22:0, 23:0, 24:5, 25:6, 26:1, 27:2, 28:3, 29:0, 30:0, 31:4],
    //November 2022
    [1:5, 2:6, 3:1, 4:2, 5:0, 6:0, 7:3, 8:4, 9:5, 10:6, 11:1, 12:0, 13:0, 14:2, 15:3, 16:4, 17:5, 18:6, 19:0, 20:0, 21:1, 22:2, 23:0, 24:0, 25:0, 26:0, 27:0, 28:0, 29:3, 30:4],
    //December 2022
    [1:5, 2:6, 3:0, 4:0, 5:1, 6:2, 7:3, 8:4, 9:5, 10:0, 11:0, 12:6, 13:1, 14:2, 15:3, 16:4, 17:0, 18:0, 19:0, 20:0, 21:0, 22:0, 23:0, 24:0, 25:0, 26:0, 27:0, 28:0, 29:0, 30:0, 31:0],
]

var cycleDay : Int {
    get {
        var date = Date()
        let cal = Calendar.current
        if globalOffset != 0 {
            date = cal.date(byAdding: .day, value: globalOffset, to: date)!
        }
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        
        let optionalCycle: Int? = dateToCycleDay[month-1][day]
        if let cycleDay = optionalCycle {
            return cycleDay
        } else { return 0 }
    }
}

func getRelativeDayText() -> String {
    if globalOffset > 0 {
        if globalOffset == 1 { return "Tomorrow" }
        else if globalOffset % 7 == 0 { return "In " + String(globalOffset / 7) + " week" + (globalOffset >= 14 ? "s" : "") }
        else { return "In " + String(globalOffset) + " days" }
    } else if globalOffset < 0 {
        if globalOffset == -1 { return "Yesterday" }
        else if -globalOffset % 7 == 0 { return String(-globalOffset / 7) + " week" + (-globalOffset >= 14 ? "s" : "") + " ago" }
        else { return String(-globalOffset) + " days ago" }
    } else {
        return ""
    }
}

func schoolDone() -> Bool{
    let date = Date()
    let cal = Calendar.current
    if cycleDay == 0 {
        return true
    }
        if (isSports()){
            return ((cal.component(.hour, from: date) > 17) || (cal.component(.hour, from: date) < 6))
        } else {
    return ((cal.component(.hour, from: date) > 15) || (cal.component(.hour, from: date) < 6))
        }
}

func isSports() -> Bool{
    //    if cycleDay == 3 || cycleDay == 6 || cycleDay == 8{
    //        return true
    //    } else {
    //        return false
    //    }
    return false
}

func nowIsBeforeBlockBegins(block: Int) -> Bool {
    switch block {
    case 9: //before sports or go home
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 15,minute2: 00)
    case 8: //before office hours
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 40)
    case 7: //before d block on day 1
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 35)
    case 6: //before Z2
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 50)
    case 5: //before Z1
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 25)
    case 4:// before c block
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 20)
    case 3:// before morning activity
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 20)
    case 2: //before b block
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 9,minute2: 45)
    case 1: //before a block on day 1
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 8,minute2: 40)
    case 0: //before house
        return isAfter(hour1: getHour(), minute1: getMinute(), hour2: 8, minute2: 30)
    default: return false
    }
}

func nowIsAfterBlockEnds(block:Int) -> Bool{
    switch block{
    case 9: //next: sports
        return isAfter(hour1: 17,minute1: 00,hour2: getHour(),minute2: getMinute())
    case 8: //next: office hours
        return isAfter(hour1: 15,minute1: 00,hour2: getHour(),minute2: getMinute())
    case 7: //next: d block on day 1
        return isAfter(hour1: 14,minute1: 35,hour2: getHour(),minute2: getMinute())
    case 6: //next: Z2
        return isAfter(hour1: 13,minute1: 30,hour2: getHour(),minute2: getMinute())
    case 5: //next: Z1
        return isAfter(hour1: 13,minute1: 05,hour2: getHour(),minute2: getMinute())
    case 4: //next: c block
        return isAfter(hour1: 12,minute1: 25,hour2: getHour(),minute2: getMinute())
    case 3: //next: morning activity
        return isAfter(hour1: 11,minute1: 20,hour2: getHour(),minute2: getMinute())
    case 2: //next: b block
        return isAfter(hour1: 10,minute1: 45,hour2: getHour(),minute2: getMinute())
    case 1: //next: a block on day 1
        return isAfter(hour1: 9,minute1: 40,hour2: getHour(),minute2: getMinute())
    case 0: //next: house
        return isAfter(hour1: 8, minute1: 35, hour2: getHour(), minute2: getMinute())
    default:
        return false
    }
}

func nowIsBeforeQuarter(block: Int, q: Int) -> Bool { //Now is before the end of the first,second,third,fourth quarter
    if q == 1{
            switch block{
            case 8: //before office hours
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 45)
            case 7: //before d block on day 1
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 50)
            case 6: //before Z2
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 00)
            case 5: //before Z1
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 35)
            case 4:// before c block
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 35)
            case 3:// before morning activity
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 54)
            case 2: //before b block
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 00)
            case 1: //before a block on day 1
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 8,minute2: 55)
            default:
                return true
            }
        }
        else if q == 2{
            switch block{
            case 8: //before office hours
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 50)
            case 7: //before d block on day 1
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 05)
            case 6: //before Z2
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 10)
            case 5: //before Z1
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 45)
            case 4:// before c block
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 50)
            case 3:// before morning activity
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 03)
            case 2: //before b block
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 15)
            case 1: //before a block on day 1
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 9,minute2: 10)
            default:
                return true
            }
            
        }
        else if q == 3{
            switch block{
            case 8: //before office hours
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 55)
            case 7: //before d block on day 1
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 20)
            case 6: //before Z2
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 20)
            case 5: //before Z1
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 55)
            case 4:// before c block
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 05)
            case 3:// before morning activity
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 12)
            case 2: //before b block
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 30)
            case 1: //before a block on day 1
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 9,minute2: 25)
            default:
                return true
            }
        }
        else if q == 4{
            switch block{
            case 7:
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 15,minute2: 00) && isAfter(hour1: 15, minute1: 00, hour2: getHour(), minute2: getMinute())
            case 6:
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 35) && isAfter(hour1: 14, minute1: 35, hour2: getHour(), minute2: getMinute())
            case 9:
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 30) && isAfter(hour1: 13, minute1: 27, hour2: getHour(), minute2: getMinute())
            case 5:
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 05) && isAfter(hour1: 13, minute1: 05, hour2: getHour(), minute2: getMinute())
            case 4:
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 20) && isAfter(hour1: 12, minute1: 20, hour2: getHour(), minute2: getMinute())
            case 3:
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 20) && isAfter(hour1: 11, minute1: 20, hour2: getHour(), minute2: getMinute())
            case 2:
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 45) && isAfter(hour1: 10, minute1: 45, hour2: getHour(), minute2: getMinute())
            case 1:
                return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 9,minute2: 40) && isAfter(hour1: 9, minute1: 40, hour2: getHour(), minute2: getMinute())
            default:
                return true
            }
        }
    return true
}

func getBlockAlmostStartTimes(_ block: Int) -> DateComponents {
    if block == 0 { return DateComponents(calendar: Calendar.current, hour: 8, minute: 28) }
    else if block == 1 { return DateComponents(calendar: Calendar.current, hour: 8, minute: 38) }
    else if block == 2 { return DateComponents(calendar: Calendar.current, hour: 9, minute: 43) }
    else if block == 3 { return DateComponents(calendar: Calendar.current, hour: 10, minute: 18) }
    else if block == 4 { return DateComponents(calendar: Calendar.current, hour: 11, minute: 18) }
    else if block == 5 { return DateComponents(calendar: Calendar.current, hour: 12, minute: 23) }
    else if block == 6 { return DateComponents(calendar: Calendar.current, hour: 12, minute: 48) }
    else if block == 7 { return DateComponents(calendar: Calendar.current, hour: 13, minute: 33) }
    else if block == 8 { return DateComponents(calendar: Calendar.current, hour: 14, minute: 38) }
    else if block == 9 { return DateComponents(calendar: Calendar.current, hour: 15, minute: 18) }
    else { return DateComponents(calendar: Calendar.current, hour: 12, minute: 00) }  // block = 9
}

func isAfter(hour1:Int,minute1: Int,hour2:Int ,minute2:Int) -> Bool{ //is time2 after time1; is time1 before time2
    if hour2>hour1{
        return true
    } else if hour1>hour2{
        return false
    } else {
        return (minute2>minute1)
    }
    
}

func getHour() -> Int{
    var date = Date()
    let cal = Calendar.current
    if globalOffset != 0 {
        date = cal.date(byAdding: .day, value: globalOffset, to: date)!
    }
    let hour = (cal.component(.hour, from: date))
    return hour
    
}

func getMinute() -> Int{
    var date = Date()
    let cal = Calendar.current
    if globalOffset != 0 {
        date = cal.date(byAdding: .day, value: globalOffset, to: date)!
    }
    let minute = cal.component(.minute, from: date)
    return minute
}

var blocks: [Int: [String]] = [
    0: ["","","","","",""], 1: ["A","B","C","Z","D"], 2: ["E","F","G","Z","H"], 3: ["D","A","B","Z","C"], 4: ["H","E","F","Z","G"], 5: ["C","D","A","Z","B"], 6: ["G","H","E","Z","F"]
]

var classes: [Int: [String]] = [
    0: ["", "", "", "", ""],
    1: ["(A Block)", "(B Block)", "(C Block)", "(Z)","(D Block)"],
    2: ["(E Block)", "(F Block)", "(G Block)", "(Z)","(H Block)"],
    3: ["(D Block)", "(A Block)", "(B Block)", "(Z)","(C Block)"],
    4: ["(H Block)", "(E Block)", "(F Block)", "(Z)","(G Block)"],
    5: ["(C Block)", "(D Block)", "(A Block)", "(Z)","(B Block)"],
    6: ["(G Block)", "(H Block)", "(E Block)", "(Z)","(F Block)"]
]

var rooms: [Int: [String]] = [ //The reason why this array is shorter than the classes array is because the fourth room is going to be either z block, whichever one actually goes to a class, and we won't need a room for lunch
    0: ["","","","",""],
    1: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"],
    2: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"],
    3: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"],
    4: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"],
    5: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"],
    6: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"]
]

var ZLunch: [Int: Int] = [0: 3, 1: 3, 2: 3, 3: 3, 4:3, 5: 3, 6: 3]//Day : 1 = Z1 lunch, 2 = Z2 lunch, 3 = Both lunch

var sports = ["XC","XC","XC","XC","XC","XC"] //TODO: Make an option for weekday dependent sports //TODO: make individual short sports names, e.g. XC, FH, BVS, TN, FC

func getLunch(day: Int, z: Int) -> String{ //Input day and z block (1 or 2), output lunch or class
    if ZLunch[day] == 3 || (ZLunch[day] == z){
        return "Lunch"
    } else {
        return classes[day]![3]
    }
}

func getMorningActivity() -> String {
    var date = Date()
    let cal = Calendar.current
    if globalOffset != 0 {
        date = cal.date(byAdding: .day, value: globalOffset, to: date)!
    }
    let weekday = cal.component(.weekday, from: date)
    switch weekday {
    case 1:
        return "None"
    case 2:
        return "Community Meeting"
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
}

func isSchoolDay() -> Bool{
    var date = Date()
    let cal = Calendar.current
    if globalOffset != 0 {
        date = cal.date(byAdding: .day, value: globalOffset, to: date)!
    }
    if cycleDay != 0 {
        return true
    } else {
        return false
    }
}

func isNextBlock(bl: Int) -> Bool {
    if nowIsBeforeBlockBegins(block: 0){
        if (bl == 0){
            return true
        } else {
            return false
        }
    } else if nowIsBeforeBlockBegins(block: 1){
        if (bl == 1){
            return true
        } else {
            return false
        }
    } else if nowIsBeforeBlockBegins(block: 2){
        if (bl == 2){
            return true
        } else {
            return false
        }
    } else if nowIsBeforeBlockBegins(block: 3){
        if (bl == 3){
            return true
        } else {
            return false
        }
    } else if nowIsBeforeBlockBegins(block: 4){
        if (bl == 4){
            return true
        } else {
            return false
        }
    } else if nowIsBeforeBlockBegins(block: 5){
        if (bl == 5){
            return true
        } else {
            return false
        }
    } else if nowIsBeforeBlockBegins(block: 6){
        if (bl == 6){
            return true
        } else {
            return false
        }
    } else if nowIsBeforeBlockBegins(block: 7){
        if (bl == 6){
            return true
        } else {
            return false
        }
    } else if nowIsBeforeBlockBegins(block: 8){
        if (bl == 7){
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

func isMeetingOrAssessment(_ block: Int, _ time: DateComponents) -> String {
    let month = time.month!
    let day = time.day!
    let begin: [Int: Bool] = [
        1: classes[dateToCycleDay[month-1][day]!]![0].starts(with: "Free") || classes[dateToCycleDay[month-1][day]!]![1].starts(with: "Study Hall"),
        2: classes[dateToCycleDay[month-1][day]!]![1].starts(with: "Free") || classes[dateToCycleDay[month-1][day]!]![2].starts(with: "Study Hall"),
        4: classes[dateToCycleDay[month-1][day]!]![2].starts(with: "Free") || classes[dateToCycleDay[month-1][day]!]![3].starts(with: "Study Hall"),
        7: classes[dateToCycleDay[month-1][day]!]![4].starts(with: "Free") || classes[dateToCycleDay[month-1][day]!]![4].starts(with: "Study Hall")
    ]
    print("block: \(block); month: \(month), day: \(day); begin: \(begin)")
    switch block {
    case 0:
        return "Meeting"
    case 1:
        return begin[1]! ? "Meeting" : "Assessment"
    case 2:
        return begin[2]! ? "Meeting" : "Assessment"
    case 3:
        return "Meeting"
    case 4:
        return begin[4]! ? "Meeting" : "Assessment"
    case 5:
        if getLunch(day: dateToCycleDay[month-1][day]!, z: 1) == "Lunch"{
            return "Meeting"
        } else {
            return "Assessment"
        }
    case 6:
        if getLunch(day: dateToCycleDay[month-1][day]!, z: 2) == "Lunch"{
            return "Meeting"
        } else {
            return "Assessment"
        }
    case 7:
        return begin[7]! ? "Meeting" : "Assessment"
    case 8:
        return "Meeting"
    default:
        return "Meeting"
    }
}

func getOffsetDate() -> String {
    var date = Date()
    let cal = Calendar.current
    if globalOffset != 0 {
        date = cal.date(byAdding: .day, value: globalOffset, to: date)!
    }
    return "\(cal.shortWeekdaySymbols[cal.component(.weekday, from: date)-1]), \(cal.shortMonthSymbols[cal.component(.month, from: date)-1]) \(cal.component(.day, from: date)), \(cal.component(.year, from: date))"
}


