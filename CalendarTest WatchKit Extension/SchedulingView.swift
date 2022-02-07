//
//  SchedulingView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 2/5/22.
//

import SwiftUI
import UserNotifications

//func hasAssessment(block: Int) -> Bool {
//    return false
//}

func getAssessmentBlock() -> Int{
    return 0//fix
}

var hasAs: [Int: [Bool]] = [
    //  Blk 1  Clubs  Blk 2  Blk 3  Lunch  Blk 4  Blk 5
    0: [false, false, false, false, false, false, false],
    1: [false, false, false, false, false, false, false],
    2: [false, false, false, false, false, false, false],
    3: [false, false, false, false, false, false, false],
    4: [false, false, false, false, false, false, false],
    5: [false, false, false, false, false, false, false],
    6: [false, false, false, false, false, false, false],
    7: [false, false, false, false, false, false, false],
    8: [false, false, false, false, false, false, false]
]
var numEvents: [Int: [Int]] = [ //cycle day, block #
    0: [0, 0, 0, 0, 0, 0, 0],
    1: [0, 0, 0, 0, 0, 0, 0],
    2: [0, 0, 0, 0, 0, 0, 0],
    3: [0, 0, 0, 0, 0, 0, 0],
    4: [0, 0, 0, 0, 0, 0, 0],
    5: [0, 0, 0, 0, 0, 0, 0],
    6: [0, 0, 0, 0, 0, 0, 0],
    7: [0, 0, 0, 0, 0, 0, 0],
    8: [0, 0, 0, 0, 0, 0, 0]
]

struct SchedulingView: View {
    var day: Int
    var block: Int
    
    @State var isEvent = false {
        didSet {
            hasAs[day]![block] = isEvent
        }
    }
    
    func meetingOrAssessment() -> String{
        let date = Date()
        let cal = Calendar.current
        let weekday = cal.component(.weekday, from: date)
        switch block {
        case 0:
            return classes[day]![0].starts(with: "Free") ? "Meeting" : "Assessment"
        case 1:
            return weekday == 3 || weekday == 5 ? "Meeting" : "Event"
        case 2:
            return classes[day]![1].starts(with: "Free") ? "Meeting" : "Assessment"
        case 3:
            return classes[day]![2].starts(with: "Free") ? "Meeting" : "Assessment"
        case 4:
            return "Meeting"
        case 5:
            return classes[day]![3].starts(with: "Free") ? "Meeting" : "Assessment"
        case 6:
            return classes[day]![4].starts(with: "Free") ? "Meeting" : "Assessment"
        default:
            return "e"
        }
    }
    
    func getPeriod(blockNum: Int) -> String {
        switch blockNum {
        case 0:
            return blocks[day]![0] + " Block"
        case 1:
            return "Break/Clubs"
        case 2:
            return blocks[day]![1] + " Block"
        case 3:
            return blocks[day]![2] + " Block"
        case 4:
            return "Lunch"
        case 5:
            return blocks[day]![3] + " Block"
        case 6:
            return blocks[day]![4] + " Block"
        default:
            return "e"
        }
    }
    
    var body: some View {
        VStack {
            Text("Add Event").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
            Text(getOffsetDate())
            Text("Day \(day), \(getPeriod(blockNum: block))")
            Divider().padding(.vertical, 5)
            if meetingOrAssessment() == "Meeting" {
                Button(action: {
                    isEvent = true
                    // *** Schedule Meeting Notification ***
                    let content = UNMutableNotificationContent()
                    // TODO: pass in values here; see ScheduleNotificationView for where the values will be displayed
                    content.title = "Reminder: Meeting"
                    content.subtitle = ("Day " + String(day) + ", " + getPeriod(blockNum: block))
                    content.sound = UNNotificationSound.default
                    content.body = "Reminder: You have a meeting this block."
                    content.categoryIdentifier = "event"
                    numEvents[day]![block] += 1
                    let category = UNNotificationCategory(identifier: "event", actions: [], intentIdentifiers: [], options: [])
                    UNUserNotificationCenter.current().setNotificationCategories([category])
                    
                    // TODO: use the cycle day and block instance variables, as well as any methods we have, to calculate the components for the date that we need to trigger the notification
                    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: false)

                    // TODO: somehow construct a unique identifier string from the date and class or block information; do it in such a way as to ensure that any other meeting we schedule into some other block cannot possibly have the same string
                    let request = UNNotificationRequest(identifier: "[insert id here]", content: content, trigger: trigger)

                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                }, label: { Text("Schedule Meeting").fontWeight(.medium) })
            } else if meetingOrAssessment() == "Assessment"{
                Button(action: {
                    isEvent = true
                    // *** Schedule Assessment Notification ***
                    let content = UNMutableNotificationContent()
                    // TODO: pass in values here; see ScheduleNotificationView for where the values will be displayed
                    content.title = "Reminder: Assessment"
                    content.subtitle = ("Day " + String(day) + ", " + getPeriod(blockNum: block))
                    content.sound = UNNotificationSound.default
                    content.body = "Reminder: You have an assessment this block. Good luck!"
                    content.categoryIdentifier = "event"
                    numEvents[day]![block] += 1

                    let category = UNNotificationCategory(identifier: "event", actions: [], intentIdentifiers: [], options: [])
                    UNUserNotificationCenter.current().setNotificationCategories([category])
                    
                    // TODO: use the cycle day and block instance variables, as well as any methods we have, to calculate the components for the date that we need to trigger the notification
                    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: false)

                    // TODO: somehow construct a unique identifier string from the date and class or block information; do it in such a way as to ensure that any other assessment we schedule into some other block cannot possibly have the same string
                    let request = UNNotificationRequest(identifier: "[insert id here]", content: content, trigger: trigger)

                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                }, label: { Text("Input Assessment").fontWeight(.medium) })
            } else {
                Button(action: {
                    isEvent = true
                    // *** Schedule Assessment Notification ***
                    let content = UNMutableNotificationContent()
                    // TODO: pass in values here; see ScheduleNotificationView for where the values will be displayed
                    content.title = "Reminder: Event"
                    content.subtitle = ("Day " + String(day) + ", " + getPeriod(blockNum: block))
                    content.sound = UNNotificationSound.default
                    content.body = "Reminder: You have an event this block."
                    content.categoryIdentifier = "event"
                    numEvents[day]![block] += 1

                    let category = UNNotificationCategory(identifier: "event", actions: [], intentIdentifiers: [], options: [])
                    UNUserNotificationCenter.current().setNotificationCategories([category])
                    
                    // TODO: use the cycle day and block instance variables, as well as any methods we have, to calculate the components for the date that we need to trigger the notification
                    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: false)

                    // TODO: somehow construct a unique identifier string from the date and class or block information; do it in such a way as to ensure that any other assessment we schedule into some other block cannot possibly have the same string
                    let request = UNNotificationRequest(identifier: "[insert id here]", content: content, trigger: trigger)

                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                }, label: { Text("Input Assessment").fontWeight(.medium) })
            }
        }
    }
}

struct SchedulingView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulingView(day: 4, block: 1)
    }
}
