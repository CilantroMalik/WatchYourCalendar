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


//var userData: [String: Any] = Connectivity.shared.data {
//    didSet {
//        print("Received user data from WatchConnectivity")
//        for i in 0...7 {
//            lunchBlockFirst[i+1] = [userData["firstLunch"]![i]]
//        }
//        let (a, b, c, d, e, f, g, h] = userData["classes"]!
//        classes[1] = [c, e, d, a, b, "Sports/Go Home"]
//        classes[2] = [f, g, h, a, b, "Sports/Go Home"]
//        classes[3] = [c, d, f, e, g, "Sports/Go Home"]
//        classes[4] = [h, a, b, c, d, "Sports/Go Home"]
//        classes[5] = [g, a, h, e, f, "Sports/Go Home"]
//        classes[6] = [b, c, d, e, f, "Sports/Go Home"]
//        classes[7] = [a, h, g, b, c, "Sports/Go Home"]
//        classes[8] = [d, e, f, g, h, "Sports/Go Home"]
//    }
//}


var cancellable = Connectivity.shared.$data.sink() {
    var lunches = $0["firstLunch"]! as! [Bool]
    var classArr = $0["classes"]! as! [String]
    print("Received user data update. THIS MEANS THE DATA REACHED THE WATCH :)")
    for i in 0...7 {
        lunchBlockFirst[i+1] = [lunches[i]]
    }
    let a = classArr[0]
    let b = classArr[1]
    let c = classArr[2]
    let d = classArr[3]
    let e = classArr[4]
    let f = classArr[5]
    let g = classArr[6]
    let h = classArr[7]
    classes[1] = [c, e, d, a, b, "Sports/Go Home"]
    classes[2] = [f, g, h, a, b, "Sports/Go Home"]
    classes[3] = [c, d, f, e, g, "Sports/Go Home"]
    classes[4] = [h, a, b, c, d, "Sports/Go Home"]
    classes[5] = [g, a, h, e, f, "Sports/Go Home"]
    classes[6] = [b, c, d, e, f, "Sports/Go Home"]
    classes[7] = [a, h, g, b, c, "Sports/Go Home"]
    classes[8] = [d, e, f, g, h, "Sports/Go Home"]
    
    UserDefaults.standard.set(lunches, forKey: "firstLunch")
    UserDefaults.standard.set(classArr, forKey: "classes")
    
    var ud = UserData()
    ud.updateClasses(classes)
    ud.updateLunch(lunchBlockFirst)
}


class UserData: ObservableObject {
    // TODO replace this with generic placeholder
    static var classes: [Int: [String]] = [
        0: ["","","","","",""],
        1: [" (A)", " (B)", " (C)", " (Z1)", " (Z2)"," (D)"],
        2: [" (E)", " (F)", " (G)", " (Z1)", " (Z2)"," (H)"],
        3: [" (D)", " (A)", " (B)", " (Z1)", " (Z2)"," (C)"],
        4: [" (H)", " (E)", " (F)", " (Z1)", " (Z2)"," (G)"],
        5: [" (A)", " (B)", " (C)", " (Z1)", " (Z2)"," (D)"],
        6: [" (A)", " (B)", " (C)", " (Z1)", " (Z2)"," (D)"],
        
    ]
    static var lunchBlockFirst: [Int: [Bool]] = [0: [false], 1: [false], 2: [false], 3: [false], 4:[false], 5: [false], 6: [false], 7: [false], 8: [false]]
    
    func updateClasses(_ new: [Int: [String]]) {
        UserData.classes = new
        objectWillChange.send()
    }
    
    func updateLunch(_ new: [Int: [Bool]]) {
        UserData.lunchBlockFirst = new
        objectWillChange.send()
    }
}


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
    content.title = "Good morning!"
    content.sound = UNNotificationSound.default
    content.body = "Here's your daily overview."
    content.categoryIdentifier = "sports"
    
    // enable the line below for testing notifications: shows one seconds after app launch
    //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    for i in 2...6 {
                let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, hour: 8, minute: 0, weekday: i), repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: "dailyNotif", content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
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
    let date = Date()
    let cal = Calendar.current
    let month = cal.component(.month, from: date)
    let day = cal.component(.day, from: date)
    let content = UNMutableNotificationContent()
    content.title = "Lunch is ending!"
    content.subtitle = ""
    content.sound = UNNotificationSound.default
    content.body = "10 minutes left until your next class."
    content.categoryIdentifier = "lunch"
    
    // enable the line below for testing notifications: shows five seconds after app launch
    //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
    for i in 2...6 {
//        if lunchBlockFirst[(dateToCycleDay[month-1][day - 2 + i]!)]! == [true]{
        let trigger = (lunchBlockFirst[(dateToCycleDay[month-1][day - 2 + i]!)]! == [true]) ? UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, hour: 12, minute: 15, weekday: i), repeats: true) : UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, hour: 13, minute: 10, weekday: i), repeats: true)
//        } else {
//            let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, hour: 13, minute: 10, weekday: i), repeats: true)
//        }
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: "lunchNotif\(i)", content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}

public var nextClass = 0
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
func getDate() -> String {
    let date = Date()
    let cal = Calendar.current
    return String(cal.component(.month, from: date)) + "/" + String(cal.component(.day, from: date)) + "/" + String(cal.component(.year, from: date))
}
func getCycleDayDay() -> String{
    if cycleDay != 0{
        return "Day " + String(cycleDay)
    } else {
        return "OFF"
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

func getOffsetDate() -> String {
    var date = Date()
    let cal = Calendar.current
    if globalOffset != 0 {
        date = cal.date(byAdding: .day, value: globalOffset, to: date)!
    }
    return "\(cal.shortWeekdaySymbols[cal.component(.weekday, from: date)-1]), \(cal.shortMonthSymbols[cal.component(.month, from: date)-1]) \(cal.component(.day, from: date)), \(cal.component(.year, from: date))"
}

func isSports() -> Bool{
    //    if cycleDay == 3 || cycleDay == 6 || cycleDay == 8{
    //        return true
    //    } else {
    //        return false
    //    }
    return false
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
var classes: [Int: [String]] = [:]//TODO: input
var rooms: [Int: [String]] = [
    0: ["","","","",""],
    1: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"],
    2: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"],
    3: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"],
    4: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"],
    5: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"],
    6: ["US Room 100", "US Room 100", "US Room 100", "US Room 100", "US Room 100"]
]
func getClassess(day: Int,block: Int) -> String{//TODO: input
    switch block {
    case 0:
        return classes[day]![0]
    case 1:
        return getMorningActivity()
    case 2:
        return classes[day]![1]
    case 3:
        return classes[day]![2]
    case 4:
        return "Lunch"
    case 5:
        return classes[day]![3]
    case 6:
        return classes[day]![4]
    case 7:
        return classes[day]![5]
    case 9:
        return "Break"
    default:
        return "eeee"
    }
}
var blocks: [Int: [String]] = [
    0: ["","","",""], 1: ["A","B","C","D"], 2: ["E","F","G","H"], 3: ["D","A","B","C"], 4: ["H","E","F","G"], 5: ["C","D","A","B"], 6: ["G","H","E","F"]
]
var blockOrder: [Int: [String]] = [
    0: ["—"], 1: ["ABCD"], 2: ["EFGH"], 3:["DABC"], 4:["HEFG"], 5:["CDAB"], 6:["GHEF"]
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
    } else if nowIsBeforeBlockBegins(block: 9){
        if (bl == 9){
            return true
        } else {
            return false
        }
    } else {
        return false
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
func nowIsAfterBlockEnds(block:Int) -> Bool{
    if block == 7 { //go home
        return isAfter(hour1: 15,minute1: 20,hour2: getHour(),minute2: getMinute())
    } else if block == 6 { //sports or go home
        return isAfter(hour1: 14,minute1: 30,hour2: getHour(),minute2: getMinute())
    } else if block == 9 { //next: last block
        return isAfter(hour1: 14,minute1: 20,hour2: getHour(),minute2: getMinute())
    } else if block == 5 { //next: break
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
    } else if block == 9 { //before break
        return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 20)
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
func nowIsBeforeThird(block: Int, third: Int) -> Bool {
    if third == 1{
        if block == 7 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 15,minute2: 15)
        } else if block == 6 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 30)
        } else if block == 9 { //before break
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 20)
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
    } else if third == 2{
        if block == 7 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 15,minute2: 15)//not necessary
        } else if block == 6 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 45)
        } else if block == 9 { //before break
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 23)
        } else if block == 5 { //before
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 40)
        } else if block == 4 {//before lunch
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 45)
        } else if block == 3 {//
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 45)
        } else if block == 2 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 50)
        }else if block == 1 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 10)
        } else if block == 0 { //before first block
            return isAfter(hour1: getHour(), minute1: getMinute(), hour2: 9, minute2: 15)
        }
    } else if third == 3{
        if block == 7 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 15,minute2: 15)
        } else if block == 6 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 15,minute2: 00)
        } else if block == 9 { //before break
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 27)
        } else if block == 5 { //before
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 00)
        } else if block == 4 {//before lunch
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 00)
        } else if block == 3 {//
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 05)
        } else if block == 2 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 05)
        }else if block == 1 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 20)
        } else if block == 0 { //before first block
            return isAfter(hour1: getHour(), minute1: getMinute(), hour2: 9, minute2: 35)
        }
    } else if third == 4{
        if block == 7 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 15,minute2: 15) && isAfter(hour1: 15, minute1: 15, hour2: getHour(), minute2: getMinute())
        } else if block == 6 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 15,minute2: 15) && isAfter(hour1: 15, minute1: 00, hour2: getHour(), minute2: getMinute())
        } else if block == 9 { //before break
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 30) && isAfter(hour1: 14, minute1: 27, hour2: getHour(), minute2: getMinute())
        } else if block == 5 { //before
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 20) && isAfter(hour1: 14, minute1: 00, hour2: getHour(), minute2: getMinute())
        } else if block == 4 {//before lunch
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 15) && isAfter(hour1: 13, minute1: 00, hour2: getHour(), minute2: getMinute())
        } else if block == 3 {//
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 12,minute2: 25) && isAfter(hour1: 12, minute1: 05, hour2: getHour(), minute2: getMinute())
        } else if block == 2 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 20) && isAfter(hour1: 11, minute1: 05, hour2: getHour(), minute2: getMinute())
        }else if block == 1 { //
            return isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 30) && isAfter(hour1: 10, minute1: 20, hour2: getHour(), minute2: getMinute())
        } else if block == 0 { //before first block
            return isAfter(hour1: getHour(), minute1: getMinute(), hour2: 9, minute2: 55) && isAfter(hour1: 9, minute1: 35, hour2: getHour(), minute2: getMinute())
        }
    }
    return true
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
}
func getShortMorningActivity() -> String {
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
        return "Comm. Meet."
    case 3:
        return "Clubs"
    case 4:
        return "Advisory"
    case 5:
        return "Clubs"
    case 6:
        return "Class Mt."
    case 7:
        return "None"
    default:
        return "error... lul"
    }
}
func schoolDone() -> Bool{
    let date = Date()
    let cal = Calendar.current
    if cycleDay == 0 {
        return true
    }
    //    if (isSports()){
    //        return ((cal.component(.hour, from: date) > 16) || ((cal.component(.hour, from: date) > 15 && cal.component(.minute, from: date) > 10)) || (cal.component(.hour, from: date) < 7))
    //    } else {
    return ((cal.component(.hour, from: date) > 15) || ((cal.component(.hour, from: date) > 14 && cal.component(.minute, from: date) > 15)) || (cal.component(.hour, from: date) < 7))
    //    }
}


func school() -> Bool{
    return isSchoolDay() && !schoolDone()
}
var lunchBlockFirst: [Int: [Bool]] = [
    0: [false], 1: [false], 2: [false], 3: [false], 4:[false], 5: [false], 6: [false], 7: [false], 8: [false] //teehee imagine having first lunch
]

//COMPLICATIONS (functions start with "comp" in order to avoid confusion with other methods

func timeIsBeforeBlockBegins(date: Date, block: Int) -> Bool{
    let hr = Calendar.current.component(.hour, from: date)
    let min = Calendar.current.component(.minute, from: date)
    if block == 7 { //
        return isAfter(hour1: hr,minute1: min,hour2: 15,minute2: 15)
    } else if block == 6 { //
        return isAfter(hour1: hr,minute1: min,hour2: 14,minute2: 30)
    } else if block == 9 { //before break
        return isAfter(hour1: hr,minute1: min,hour2: 14,minute2: 20)
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
    } else if timeIsBeforeBlockBegins(date: now, block: 9){
        let comp = DateComponents(calendar: cal, hour: 14, minute: 20, second:00)
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
        return "L"
    } else if timeIsBeforeBlockBegins(date: date, block: 5){
        return (blocks[cycleDay]![3])
    } else if timeIsBeforeBlockBegins(date: date, block: 9){
        return "OH" //for office hours break
    } else if timeIsBeforeBlockBegins(date: date, block: 6){
        return (blocks[cycleDay]![4])
    } else {
        return ("—")
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
    } else if timeIsBeforeBlockBegins(date: date, block: 9){
        return 5
    } else if timeIsBeforeBlockBegins(date: date, block: 6){
        return 9
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
    } else if timeIsBeforeBlockBegins(date: date, block: 9){
        return "OH"
    } else if timeIsBeforeBlockBegins(date: date, block: 7){
        return (blocks[cycleDay]![4])
    } else{
        return "—"
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
    } else if block == 9 {
        return 10
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
        return "Next: \(getShortMorningActivity())"
    } else if timeIsBeforeBlockBegins(date: date, block: 2){
        return "Next: \(classes[cycleDay]![1])"
    } else if timeIsBeforeBlockBegins(date: date, block: 3){
        return "Next: \(classes[cycleDay]![2])"
    } else if timeIsBeforeBlockBegins(date: date, block: 4){
        return "Next: Lunch"
    } else if timeIsBeforeBlockBegins(date: date, block: 5){
        return "Next: \(classes[cycleDay]![3])"
    } else if timeIsBeforeBlockBegins(date: date, block: 9){
        return "Next: Break"
    } else if timeIsBeforeBlockBegins(date: date, block: 6){
        return "Next: \(classes[cycleDay]![4])"
    } else if timeIsBeforeBlockBegins(date: date, block: 7){
        return "Next: \(classes[cycleDay]![5])"
    } else {
        return "—"
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
    } else if timeIsBeforeBlockBegins(date: date, block: 9){
        return "Break"
    } else if timeIsBeforeBlockBegins(date: date, block: 6){
        return "\(classes[cycleDay]![4])"
    } else if timeIsBeforeBlockBegins(date: date, block: 7){
        return "\(classes[cycleDay]![5])"
    } else {
        return "—"
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
    } else if timeIsBeforeBlockBegins(date: date, block: 9){
        return "Next: Break"
    } else if timeIsBeforeBlockBegins(date: date, block: 7){
        return "\(classes[cycleDay]![4])"
    } else if timeIsBeforeBlockBegins(date: date, block: 9){
        return "\(classes[cycleDay]![5])"
    } else {
        return "—"
    }
}


func compGetTime(dc: DateComponents) -> String {
    return String((dc.hour! * 60) + dc.minute!)
}

func compGetTimeUntil(date: Date) -> String {
    if !schoolDone(){
        if nowIsAfterBlockEnds(block: 6){
            return ""
        } else {
            return " in " + String(compGetTime(dc: getTimeUntilNextClass(dc: compBeginningTimeOfBlock(now: date), now: date))) + "m"
        }
    } else {
        return "—"
    }
}

func compGetDayGigue(now: Date) -> Float {
    if cycleDay == 0 {return 1.0}
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
    if !schoolDone(){
        let minsPassed = compMinsSinceClassStart(now: now)
        return "\(length - minsPassed)m"
    } else {
        return "—"
    }
}

func compGetClassGigue(length: Int, now: Date) -> Float {
    if !school(){return 1} else {
        let mins = Float(compMinsSinceClassStart(now: now))
        if mins < 0 { return 0.0 }
        if mins > Float(length) { return 1.0 }
        return Float(mins / Float(length))
    }
}

func getBlockAlmostStartTimes(_ block: Int) -> DateComponents {
    if block == 0 { return DateComponents(calendar: Calendar.current, hour: 8, minute: 52) }
    else if block == 1 { return DateComponents(calendar: Calendar.current, hour: 9, minute: 57) }
    else if block == 2 { return DateComponents(calendar: Calendar.current, hour: 10, minute: 32) }
    else if block == 3 { return DateComponents(calendar: Calendar.current, hour: 11, minute: 22) }
    else if block == 4 { return DateComponents(calendar: Calendar.current, hour: 12, minute: 27) }
    else if block == 5 { return DateComponents(calendar: Calendar.current, hour: 1, minute: 17) }
    else if block == 6 { return DateComponents(calendar: Calendar.current, hour: 2, minute: 27) }
    else if block == 7 { return DateComponents(calendar: Calendar.current, hour: 3, minute: 12) }
    else { return DateComponents(calendar: Calendar.current, hour: 2, minute: 17) }  // block = 9
}

func isMeetingOrAssessment(_ block: Int, _ time: DateComponents) -> String {
    let month = time.month!
    let day = time.day!
    switch block {
    case 0:
        return classes[dateToCycleDay[month-1][day]!]![0].starts(with: "Free") ? "Meeting" : "Assessment"
    case 1:
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
