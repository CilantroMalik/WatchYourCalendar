//
//  EventView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 2/15/22.
//

import SwiftUI
import UserNotifications

struct EventView: View {
    var dc: DateComponents
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
    var day : Int
    var block : Int
    var ev : Int
    var body: some View {
        Text("Edit Event").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
        Text(getOffsetDate())
        Text("Day \(day), \(getPeriod(blockNum: block))")
        Divider().padding(.vertical, 5)
            
        Button(action: {
            numEvents[block][dc]! -= 1
        }, label: {Text("Delete Event").fontWeight(.heavy).multilineTextAlignment(.center)})
        
        if meetingOrAssessment() == "Meeting" {
            Button(action: {
                // *** Schedule Meeting Notification ***
                let content = UNMutableNotificationContent()
                // TODO: pass in values here; see ScheduleNotificationView for where the values will be displayed
                content.title = "Reminder: Meeting"
                content.subtitle = ("Day " + String(day) + ", " + getPeriod(blockNum: block))
                content.sound = UNNotificationSound.default
                content.body = "Reminder: You have a meeting this block."
                content.categoryIdentifier = "event"
                let category = UNNotificationCategory(identifier: "event", actions: [], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([category])
                
                // TODO: use the cycle day and block instance variables, as well as any methods we have, to calculate the components for the date that we need to trigger the notification
                let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: false)

                // TODO: somehow construct a unique identifier string from the date and class or block information; do it in such a way as to ensure that any other meeting we schedule into some other block cannot possibly have the same string
                let request = UNNotificationRequest(identifier: "[insert id here]", content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }, label: { Text("Be notified!").fontWeight(.medium) })
        } else if meetingOrAssessment() == "Assessment"{
            Button(action: {
                // *** Schedule Assessment Notification ***
                let content = UNMutableNotificationContent()
                // TODO: pass in values here; see ScheduleNotificationView for where the values will be displayed
                content.title = "Reminder: Assessment"
                content.subtitle = ("Day " + String(day) + ", " + getPeriod(blockNum: block))
                content.sound = UNNotificationSound.default
                content.body = "Reminder: You have an assessment this block. Good luck!"
                content.categoryIdentifier = "event"

                let category = UNNotificationCategory(identifier: "event", actions: [], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([category])
                
                // TODO: use the cycle day and block instance variables, as well as any methods we have, to calculate the components for the date that we need to trigger the notification
                let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: false)

                // TODO: somehow construct a unique identifier string from the date and class or block information; do it in such a way as to ensure that any other assessment we schedule into some other block cannot possibly have the same string
                let request = UNNotificationRequest(identifier: "[insert id here]", content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }, label: { Text("Be notified!").fontWeight(.medium) })
        } else {
            Button(action: {
                // *** Schedule Assessment Notification ***
                let content = UNMutableNotificationContent()
                // TODO: pass in values here; see ScheduleNotificationView for where the values will be displayed
                content.title = "Reminder: Event"
                content.subtitle = ("Day " + String(day) + ", " + getPeriod(blockNum: block))
                content.sound = UNNotificationSound.default
                content.body = "Reminder: You have an event this block."
                content.categoryIdentifier = "event"

                let category = UNNotificationCategory(identifier: "event", actions: [], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([category])
                
                // TODO: use the cycle day and block instance variables, as well as any methods we have, to calculate the components for the date that we need to trigger the notification
                let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: false)

                // TODO: somehow construct a unique identifier string from the date and class or block information; do it in such a way as to ensure that any other assessment we schedule into some other block cannot possibly have the same string
                let request = UNNotificationRequest(identifier: "[insert id here]", content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }, label: { Text("Be notified!").fontWeight(.medium) })
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(dc:DateComponents(calendar: Calendar.current), day: 4, block: 1,ev: 2)
    }
}
