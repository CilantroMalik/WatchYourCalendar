//
//  Utilities.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/30/22.
//

import Foundation
import WatchKit
import ClockKit
import UserNotifications

func scheduleRefresh() {
    let refreshTime = Date().advanced(by: 900)
    WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: refreshTime, userInfo: nil, scheduledCompletion: {_ in print("Scheduled task") })
}

func reloadActiveComplications() {
    let server = CLKComplicationServer.sharedInstance()

    for complication in server.activeComplications ?? [] {
        server.reloadTimeline(for: complication)
    }
}

func scheduleSportsNotification() {
    var alreadyScheduled = false
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
        for request in requests {
            if request.identifier == "dailyNotif" {
                alreadyScheduled = true
            }
        }
    }
    if alreadyScheduled { return }
    
    let content = UNMutableNotificationContent()
    content.title = "e"
    content.subtitle = "e"
    content.sound = UNNotificationSound.default
    content.body = "e"
    content.categoryIdentifier = "sports"

    let category = UNNotificationCategory(identifier: "sports", actions: [], intentIdentifiers: [], options: [])
    UNUserNotificationCenter.current().setNotificationCategories([category])
    
    // enable the line below for testing notifications: shows five seconds after app launch
    //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), repeats: true)

    // choose a random identifier
    let request = UNNotificationRequest(identifier: "dailyNotif", content: content, trigger: trigger)

    // add our notification request
    UNUserNotificationCenter.current().add(request)
}

func scheduleLunchNotification() {
    var alreadyScheduled = false
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
        for request in requests {
            if request.identifier.starts(with: "lunchNotif") {
                alreadyScheduled = true
            }
        }
    }
    if alreadyScheduled { return }
    
    let content = UNMutableNotificationContent()
    content.title = "e"
    content.subtitle = "e"
    content.sound = UNNotificationSound.default
    content.body = "e"
    content.categoryIdentifier = "lunch"

    let category = UNNotificationCategory(identifier: "lunch", actions: [], intentIdentifiers: [], options: [])
    UNUserNotificationCenter.current().setNotificationCategories([category])
    
    // enable the line below for testing notifications: shows five seconds after app launch
    //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
    for i in 2...6 {
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, hour: 13, minute: 12, weekday: i), repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: "lunchNotif\(i)", content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}

public var nextClass = 0
var dateToCycleDay: [[Int: Int]] = [
    // January
    [1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0, 10:0, 11:0, 12:0, 13:0, 14:0, 15:0, 16:0, 17:0, 18:0, 19:0, 20:0, 21:0, 22:0, 23:0, 24:7, 25:8, 26:1, 27:2, 28:3, 29:0, 30:0, 31:4],
    // February
    [1:5, 2:6, 3:7, 4:8, 5:0, 6:0, 7:1, 8:2, 9:3, 10:4, 11:5, 12:0, 13:0, 14:7, 15:7, 16:8, 17:1, 18:0, 19:0, 20:0, 21:0, 22:2, 23:3, 24:4, 25:5, 26:0, 27:0, 28:6],
    // March
    [1:7, 2:8, 3:1, 4:2, 5:0, 6:0, 7:3, 8:4, 9:5, 10:6, 11:7, 12:0, 13:0, 14:0, 15:0, 16:0, 17:0, 18:0, 19:0, 20:0, 21:0, 22:0, 23:0, 24:0, 25:0, 26:0, 27:0, 28:8, 29:1, 30:2, 31:3],
    // April
    [1:4, 2:0, 3:0, 4:5, 5:6, 6:7, 7:8, 8:1, 9:0, 10:0, 11:2, 12:3, 13:4, 14:5, 15:0, 16:0, 17:0, 18:6, 19:7, 20:8, 21:1, 22:2, 23:0, 24:0, 25:3, 26:4, 27:5, 28:6, 29:7, 30:0],
    // May
    [1:0, 2:8, 3:1, 4:2, 5:3, 6:4, 7:0, 8:0, 9:5, 10:6, 11:7, 12:8, 13:1, 14:0, 15:0, 16:2, 17:3, 18:4, 19:5, 20:6, 21:0, 22:0, 23:7, 24:8, 25:1, 26:2, 27:3, 28:0, 29:0, 30:0, 31:4],
    // June
    [1:5, 2:6, 3:7, 4:0, 5:0, 6:8, 7:1, 8:0]
]
var cycleDay : Int {
    get {
        var date = Date()
        let cal = Calendar.current
        if globalOffset != 0 {
            date = cal.date(byAdding: .day, value: globalOffset, to: date)!
        }
        var month = cal.component(.month, from: date)
        var day = cal.component(.day, from: date)
        if month >= 6 && day >= 8 {
            month = 6
            day = 8
        }
        let optionalCycle: Int? = dateToCycleDay[month-1][day]
        if let cycleDay = optionalCycle {
            return cycleDay
        } else { return 0 }
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

func isSports() -> Bool{
    if cycleDay == 3 || cycleDay == 6 || cycleDay == 8{
        return true
    } else {
        return false
    }
}
var classes: [Int: [String]] = [
    0: ["","","","","",""],
    1: ["Comp Sci (C)", "English (E)", "Physics (D)", "Free/OPI (A)", "Publ. Sp. (B)","Go Home!"],
    2: ["Latin (F)", "Spanish (G)", "Precalc (H)", "Math Team (A)", "Publ. Sp. (B)","Go Home!"],
    3: ["Comp Sci (C)", "Physics (D)", "Latin (F)", "English (E)", "Spanish (G)", "Fitness Center"],
    4: ["Precalc (H)", "Free (A)", "Publ. Sp. (B)", "Comp Sci (C)", "Physics (D)","Go Home!"],
    5: ["Spanish (G)", "Math Team (A)", "Precalc (H)", "English (E)", "Latin (F)","Go Home!"],
    6: ["Publ. Sp. (B)", "Comp Sci (C)", "Physics (D)", "English (E)", "Latin (F)","Fitness Center"],
    7: ["Free (A)", "Precalc (H)", "Spanish (G)", "Publ. Sp. (B)", "Comp Sci (C)","Go Home!"],
    8: ["Physics (D)", "English (E)", "Latin (F)", "Spanish (G)", "Precalc (H)","Fitness Center"]
]
var blocks: [Int: [String]] = [
    0: ["","","","",""], 1: ["C","E","D","A","B"], 2: ["F","G","H","A","B"], 3:["C","D","F","E","G"], 4:["H","A","B","C","D"], 5:["G","A","H","E","F"], 6:["B","C","D","E","F"], 7:["A","H","G","B","C"], 8:["D","E","F","G","H"]
]
var blockOrder: [Int: [String]] = [
    0: ["OFF"], 1: ["CEDAB"], 2: ["FGHAB"], 3:["CDFEG"], 4:["HABCD"], 5:["GAHEF"], 6:["BCDEF"], 7:["AHGBC"], 8:["DEFGH"]
]
func isAfter(hour1:Int,minute1: Int,hour2:Int ,minute2:Int) -> Bool{ //is time2 after time1
    if hour2>hour1{
        return true
    } else if hour1>hour2{
        return false
    } else {
        return (minute2>minute1)
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
    } else if nowIsBeforeBlockBegins(block: 6){
        if (bl == 6){
            return true
        } else {
            return false
        }
    } else if nowIsBeforeBlockBegins(block: 7){
        if (bl == 7){
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}
func isSchool() -> Bool{
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
func nowIsAfterBlockEnds(block:Int) -> Bool{
    if block == 7 { //go home
        return isAfter(hour1: 15,minute1: 20,hour2: getHour(),minute2: getMinute())
    } else if block == 6 { //sports or go home
        return isAfter(hour1: 14,minute1: 30,hour2: getHour(),minute2: getMinute())
    } else if block == 5 { //next: last block
        return isAfter(hour1: 13,minute1: 20,hour2: getHour(),minute2: getMinute())
    } else if block == 4 {// next: afterlunch block
        return isAfter(hour1: 12,minute1: 30,hour2: getHour(),minute2: getMinute())
    } else if block == 3 {// next: lunch
        return isAfter(hour1: 11,minute1: 25,hour2: getHour(),minute2: getMinute())
    } else if block == 2 { //next: block 3
        return isAfter(hour1: 10,minute1: 35,hour2: getHour(),minute2: getMinute())
    }else if block == 1 { //next: block 2
            return isAfter(hour1: 10,minute1: 00,hour2: getHour(),minute2: getMinute())
    } else if block == 0 { //next: morning Activity
        return isAfter(hour1: 9, minute1: 55, hour2: getHour(), minute2: getMinute())
    }
    return false
}
func nowIsBeforeBlockBegins(block: Int) -> Bool{
    if block == 7 { //
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 15,minute2: 15)
    } else if block == 6 { //
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 30)
    } else if block == 5 { //before
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 20)
    } else if block == 4 {//before lunch
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 30)
    } else if block == 3 {//
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 25)
    } else if block == 2 { //
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 35)
    }else if block == 1 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 00)
    } else if block == 0 { //before first block
        return isAfter(hour1: getHour(), minute1: getMinute(), hour2: 8, minute2: 55)
    }
    return false
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
        return "Clubs"
    case 3:
        return "Community Meeting"
//    case 2:
//        return "Community Meeting"
//    case 3:
//        return "Clubs"
    case 4:
        return "Advisory"
    case 5:
        return "Clubs"
    case 6:
        return "Class Meeting"
    case 7:
        return "None"
    default:
        return "error..."
    }
}


//COMPLICATIONS (functions start with "comp" in order to avoid confusion with other methods

func timeIsBeforeBlockBegins(date: Date, block: Int) -> Bool{
    let hr = Calendar.current.component(.hour, from: date)
    let min = Calendar.current.component(.minute, from: date)
    if block == 7 { //
        return isAfter(hour1: hr,minute1: min,hour2: 15,minute2: 15)
    } else if block == 6 { //
        return isAfter(hour1: hr,minute1: min,hour2: 14,minute2: 30)
    } else if block == 5 { //before
        return isAfter(hour1: hr,minute1: min,hour2: 13,minute2: 20)
    } else if block == 4 {//before lunch
        return isAfter(hour1: hr,minute1: min,hour2: 12,minute2: 30)
    } else if block == 3 {//
        return isAfter(hour1: hr,minute1: min,hour2: 11,minute2: 25)
    } else if block == 2 { //
        return isAfter(hour1: hr,minute1: min,hour2: 10,minute2: 35)
    }else if block == 1 { //
            return isAfter(hour1: hr,minute1: min,hour2: 10,minute2: 00)
    } else if block == 0 { //before first block
        return isAfter(hour1: hr, minute1: min, hour2: 8, minute2: 55)
    }
    return false
}

func compBeginningTimeOfBlock(now: Date = Date()) -> DateComponents {
    let cal = Calendar.current
    if timeIsBeforeBlockBegins(date: now, block: 0){
        let comp = DateComponents(calendar: cal, hour: 8, minute: 55, second:00)
        return comp
    } else if timeIsBeforeBlockBegins(date: now, block: 1){
        let comp = DateComponents(calendar: cal, hour: 10, minute: 00, second:00)
        return comp
    } else if timeIsBeforeBlockBegins(date: now, block: 2){
        let comp = DateComponents(calendar: cal, hour: 10, minute: 35, second:00)
        return comp
    } else if timeIsBeforeBlockBegins(date: now, block: 3){
        let comp = DateComponents(calendar: cal, hour: 11, minute: 25, second:00)
        return comp
    } else if timeIsBeforeBlockBegins(date: now, block: 4){
        let comp = DateComponents(calendar: cal, hour: 12, minute: 30, second:00)
        return comp
    } else if timeIsBeforeBlockBegins(date: now, block: 5){
        let comp = DateComponents(calendar: cal, hour: 13, minute: 20, second:00)
        return comp
    } else if timeIsBeforeBlockBegins(date: now, block: 6){
        let comp = DateComponents(calendar: cal, hour: 14, minute: 30, second:00)
        return comp
    } else if timeIsBeforeBlockBegins(date: now, block: 7){
        let comp = DateComponents(calendar: cal, hour: 15, minute: 20, second:00)
        return comp
    } else {
        let comp = DateComponents(calendar: cal, hour: 8, minute: 55, second:00)
        return comp
    }
}

func compGetNextBlock(date: Date) -> String{
    if cycleDay == 0{
        return ""
    } else if timeIsBeforeBlockBegins(date: date, block: 0){
        return (blocks[cycleDay]![0])
    } else if timeIsBeforeBlockBegins(date: date, block: 1){
        return "M" //activities?? or change to something nicer
    } else if timeIsBeforeBlockBegins(date: date, block: 2){
        return (blocks[cycleDay]![1])
    } else if timeIsBeforeBlockBegins(date: date, block: 3){
        return (blocks[cycleDay]![2])
    } else if timeIsBeforeBlockBegins(date: date, block: 4){
        return "L" //lunch- how many letters could we have-- given that the others are only one letter each
    } else if timeIsBeforeBlockBegins(date: date, block: 5){
        return (blocks[cycleDay]![3])
    } else if timeIsBeforeBlockBegins(date: date, block: 6){
        return (blocks[cycleDay]![4])
    } else {
        return ("X")
    }
}
func compGetNowBlock(date: Date) -> Int{
    if cycleDay == 0{
        return 0
    } else if timeIsBeforeBlockBegins(date: date, block: 1){
        return 0
    } else if timeIsBeforeBlockBegins(date: date, block: 2){
        return 1
    } else if timeIsBeforeBlockBegins(date: date, block: 3){
        return 2
    } else if timeIsBeforeBlockBegins(date: date, block: 4){
        return 3
    } else if timeIsBeforeBlockBegins(date: date, block: 5){
        return 4
    } else if timeIsBeforeBlockBegins(date: date, block: 6){
        return 5
    } else if timeIsBeforeBlockBegins(date: date, block: 7){
        return 6
    } else if isAfter(hour1: Calendar.current.component(.hour, from: date), minute1: Calendar.current.component(.hour, from: date), hour2: 15, minute2: 15){
        return 7
    } else {
        return 0
    }
}
func compGetNowBlockLetter(date: Date) -> String{
    if cycleDay == 0{
        return ""
    } else if timeIsBeforeBlockBegins(date: date, block: 1){
        return (blocks[cycleDay]![0])
    } else if timeIsBeforeBlockBegins(date: date, block: 2){
        return "M"
    } else if timeIsBeforeBlockBegins(date: date, block: 3){
        return (blocks[cycleDay]![1])
    } else if timeIsBeforeBlockBegins(date: date, block: 4){
        return (blocks[cycleDay]![2])
    } else if timeIsBeforeBlockBegins(date: date, block: 5){
        return "L"
    } else if timeIsBeforeBlockBegins(date: date, block: 6){
        return (blocks[cycleDay]![3])
    } else if timeIsBeforeBlockBegins(date: date, block: 7){
        return (blocks[cycleDay]![4])
    } else{
        return "X"
    }
}
func compGetClassLength(block: Int) -> Int{
    if block == 0{
        return 60
    } else if block == 1 {
        return 30
    } else if block == 2 {
        return 45
    } else if block == 3 {
        return 60
    } else if block == 4 {
        return 45
    } else if block == 5 {
        return 60
    } else if block == 6 {
        return 45
    } else if block == 7 {
        return 50
    } else {
        return 99
    }
}
func compGetOrder() -> String{
    return (blockOrder[cycleDay]![0])
}

func compLongNextClass(date: Date) -> String {
    if cycleDay == 0 {
        return "None"
    } else if timeIsBeforeBlockBegins(date: date, block: 0){
        return "First: \(classes[cycleDay]![0])"
    } else if timeIsBeforeBlockBegins(date: date, block: 1){
        return "Next: \(getMorningActivity())"
    } else if timeIsBeforeBlockBegins(date: date, block: 2){
        return "Next: \(classes[cycleDay]![1])"
    } else if timeIsBeforeBlockBegins(date: date, block: 3){
        return "Next: \(classes[cycleDay]![2])"
    } else if timeIsBeforeBlockBegins(date: date, block: 4){
        return "Next: Lunch"
    } else if timeIsBeforeBlockBegins(date: date, block: 5){
        return "Next: \(classes[cycleDay]![3])"
    } else if timeIsBeforeBlockBegins(date: date, block: 6){
        return "Next: \(classes[cycleDay]![4])"
    } else if timeIsBeforeBlockBegins(date: date, block: 7){
        return "Next: \(classes[cycleDay]![5])"
    } else {
        return "Next: Go home!"
    }
}

func compShortNextClass(date: Date) -> String {
    if cycleDay == 0 {
        return "None"
    } else if timeIsBeforeBlockBegins(date: date, block: 0){
        return "\(classes[cycleDay]![0])"
    } else if timeIsBeforeBlockBegins(date: date, block: 1){
        return "\(getMorningActivity())"
    } else if timeIsBeforeBlockBegins(date: date, block: 2){
        return "\(classes[cycleDay]![1])"
    } else if timeIsBeforeBlockBegins(date: date, block: 3){
        return "\(classes[cycleDay]![2])"
    } else if timeIsBeforeBlockBegins(date: date, block: 4){
        return "Lunch"
    } else if timeIsBeforeBlockBegins(date: date, block: 5){
        return "\(classes[cycleDay]![3])"
    } else if timeIsBeforeBlockBegins(date: date, block: 6){
        return "\(classes[cycleDay]![4])"
    } else if timeIsBeforeBlockBegins(date: date, block: 7){
        return "\(classes[cycleDay]![5])"
    } else {
        return "Go home!"
    }
}

func compLongNowClass(date: Date) -> String {
    if cycleDay == 0 {
        return "None"
    } else if timeIsBeforeBlockBegins(date: date, block: 1){
        return "\(classes[cycleDay]![0])"
    } else if timeIsBeforeBlockBegins(date: date, block: 2){
        return "\(getMorningActivity())"
    } else if timeIsBeforeBlockBegins(date: date, block: 3){
        return "\(classes[cycleDay]![1])"
    } else if timeIsBeforeBlockBegins(date: date, block: 4){
        return "\(classes[cycleDay]![2])"
    } else if timeIsBeforeBlockBegins(date: date, block: 5){
        return "Next: Lunch"
    } else if timeIsBeforeBlockBegins(date: date, block: 6){
        return "\(classes[cycleDay]![3])"
    } else if timeIsBeforeBlockBegins(date: date, block: 7){
        return "\(classes[cycleDay]![4])"
    } else if timeIsBeforeBlockBegins(date: date, block: 9){
        return "\(classes[cycleDay]![5])"
    } else {
        return "Next: Go home!"
    }
}


func compGetTime(dc: DateComponents) -> String {
    var hr = String(dc.hour!)
    if hr.count == 1 {
        hr = "0" + hr
    }
    var mn = String(dc.minute!)
    if mn.count == 1 {
        mn = "0" + mn
    }
    
//    return hr + ":" + mn + ":" + sc
    return hr + ":" + mn
}

func compGetTimeUntil(date: Date) -> String {
    return String(compGetTime(dc: getTimeUntilNextClass(dc: compBeginningTimeOfBlock(now: date), now: date)).suffix(2)) + "m"
}

func compGetDayGigue(now: Date) -> Float {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let yearStr = formatter.string(from: Date())
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let dayStart = formatter.date(from: yearStr + " 08:40")!
    let mins = Float(Int(now.timeIntervalSince(dayStart) / 60))
    if mins < 0 { return 0.0 }
    if mins > 390 { return 1.0 }
    return Float(mins / 390.0)
}

//func compGetTimeUntilClassEnd(dc: DateComponents, now: Date = Date()) -> DateComponents {
//    let date = now
//    let cal = Calendar.current
//    let hr = dc.hour
//    let mn = dc.minute
//    let sc = dc.second
//    let comp = DateComponents(calendar: cal, hour: hr, minute: mn, second:sc)
//    let time = cal.nextDate(after: date, matching: comp, matchingPolicy: .nextTime)!
//    let diff = cal.dateComponents([.hour, .minute, .second], from: date, to: time)
//    return diff
//}
//
//func compGetTimeUntilClassEn(dc: DateComponents) -> String {
//    return ((String(dc.hour!)) + ":" + String(dc.minute!))
//}

//func compBeginningTimeOfBlock() -> DateComponents {
//      let cal = Calendar.current
//      if nowIsBeforeBlockBegins(block: 0){
//          let comp = DateComponents(calendar: cal, hour: 8, minute: 55, second:00)
//          return comp
//      } else if nowIsBeforeBlockBegins(block: 1){
//          let comp = DateComponents(calendar: cal, hour: 9, minute: 55, second:00)
//          return comp
//      } else if (nowIsBeforeBlockBegins(block: 2)){
//          let comp = DateComponents(calendar: cal, hour: 10, minute: 30, second:00)
//          return comp
//      } else if nowIsBeforeBlockBegins(block: 3){
//          let comp = DateComponents(calendar: cal, hour: 11, minute: 20, second:00)
//          return comp
//      } else if nowIsBeforeBlockBegins(block: 4){
//          let comp = DateComponents(calendar: cal, hour: 12, minute: 25, second:00)
//          return comp
//      } else if nowIsBeforeBlockBegins(block: 5){
//          let comp = DateComponents(calendar: cal, hour: 13, minute: 15, second:00)
//          return comp
//      } else if nowIsBeforeBlockBegins(block: 6){
//          let comp = DateComponents(calendar: cal, hour: 14, minute: 20, second:00)
//          return comp
//      } else if nowIsBeforeBlockBegins(block: 7){
//          let comp = DateComponents(calendar: cal, hour: 15, minute: 15, second:00)
//          return comp
//      } else {
//          let comp = DateComponents(calendar: cal, hour: 8, minute: 55, second:00)
//          return comp
//      }
//  }

func compMinsSinceClassStart(now: Date) -> Int {
    let nowBlock = compGetNowBlock(date: now)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let yearStr = formatter.string(from: Date())
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    var classStart = formatter.date(from: yearStr + " 08:40")!
    switch nowBlock {
    case 0:
        classStart = formatter.date(from: yearStr + " 08:55")!
    case 1:
        classStart = formatter.date(from: yearStr + " 10:00")!
    case 2:
        classStart = formatter.date(from: yearStr + " 10:35")!
    case 3:
        classStart = formatter.date(from: yearStr + " 11:25")!
    case 4:
        classStart = formatter.date(from: yearStr + " 12:30")!
    case 5:
        classStart = formatter.date(from: yearStr + " 13:20")!
    case 6:
        classStart = formatter.date(from: yearStr + " 14:30")!
    case 7:
        classStart = formatter.date(from: yearStr + " 15:15")!
    default:
        classStart = formatter.date(from: yearStr + " 08:40")!
    }
    return Int(now.timeIntervalSince(classStart) / 60)
}

func compGetTimeUntilClassEnds(length: Int, now: Date) -> String{
    let minsPassed = compMinsSinceClassStart(now: now)
    return "\(length - minsPassed)m"
}

func compGetClassGigue(length: Int, now: Date) -> Float {
    let mins = Float(compMinsSinceClassStart(now: now))
    if mins < 0 { return 0.0 }
    if mins > Float(length) { return 1.0 }
    return Float(mins / Float(length))
}
func schoolDone() -> Bool{
    let date = Date()
    let cal = Calendar.current
    if (isSports()){
        return (cal.component(.hour, from: date) > 4 && cal.component(.minute, from: date) > 10) || (cal.component(.hour, from: date) < 8)
    } else {
        return (cal.component(.hour, from: date) > 3 && cal.component(.minute, from: date) > 20) || (cal.component(.hour, from: date) < 8)
    }
}

//INDIVIDUAL COMPLICATION METHODS - i can make them fancy nested ? : statements later; just trying to organize my thoughts
func NextClassInGraphicCorner() -> String{
    let date = Date()
    if !schoolDone(){
    return "\(compGetNextBlock(date: date)) in \(compGetTimeUntil(date: date))"
    } else {
        return "noSchool" //fix
    }
}
func NextClassInGraphicBezel() -> String{
    let date = Date()
    if !schoolDone(){
        return "\(compLongNextClass(date: date)) in \(compGetTimeUntil(date: date))"
    } else {
        return "schooln't" //fix
    }
}
func NextClassInUtilitarianLarge() -> String{
    let date = Date()
    if !schoolDone(){
        return "\(compLongNextClass(date: date)) in \(compGetTimeUntil(date: date))"
    }else{
        return "!school" //fix
    }
}


