//
//  EventView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 2/15/22.
//

import SwiftUI
import UserNotifications

struct EventView: View {
//    func meetingOrAssessment() -> String{
//        let date = Date()
//        let cal = Calendar.current
//        let weekday = cal.component(.weekday, from: date)
//        switch block {
//        case 0:
//            return classes[day]![0].starts(with: "Free") ? "Meeting" : "Assessment"
//        case 1:
//            return weekday == 3 || weekday == 5 ? "Meeting" : "Event"
//        case 2:
//            return classes[day]![1].starts(with: "Free") ? "Meeting" : "Assessment"
//        case 3:
//            return classes[day]![2].starts(with: "Free") ? "Meeting" : "Assessment"
//        case 4:
//            return "Meeting"
//        case 5:
//            return classes[day]![3].starts(with: "Free") ? "Meeting" : "Assessment"
//        case 6:
//            return classes[day]![4].starts(with: "Free") ? "Meeting" : "Assessment"
//        default:
//            return "e"
//        }
//    }
//    func getPeriod(blockNum: Int) -> String {
//        switch blockNum {
//        case 0:
//            return blocks[day]![0] + " Block"
//        case 1:
//            return "Break/Clubs"
//        case 2:
//            return blocks[day]![1] + " Block"
//        case 3:
//            return blocks[day]![2] + " Block"
//        case 4:
//            return "Lunch"
//        case 5:
//            return blocks[day]![3] + " Block"
//        case 6:
//            return blocks[day]![4] + " Block"
//        default:
//            return "e"
//        }
//    }
    var ev : blockEvent
    var body: some View {
        Text("Edit Event").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
        Text(getOffsetDate())
        Text("Day \(ev.getDay()), \(ev.getPeriod())")
        Divider().padding(.vertical, 5)
        
         //Delete the event at its index
        Button(action: {
////            let delarray =  (eventsList[(ev.time).month! - 1][(ev.time).day!])!.filter {$0 != ev}
////            (eventsList[(ev.time).month! - 1][(ev.time).day!]) = delarray
////            (eventsList[(ev.time).month! - 1][(ev.time).day!])?.remove(at: (eventsList[(ev.time).month! - 1][(ev.time).day]).index(of: ev))
//            while let remm = (eventsList[(ev.time).month! - 1][(ev.time).day!]).index(of:ev) {
//                (eventsList[(ev.time).month! - 1][(ev.time).day!])!.remove(at: remm)
//            }
            //delete event from list? pls help :(
        }, label: {Text("Delete Event").fontWeight(.heavy).multilineTextAlignment(.center)})
        
        if ev.meetingOrAssessment() == "Meeting" {
            Button(action: {
                ev.hasNotification = true
                // *** Schedule Meeting Notification ***
                let content = UNMutableNotificationContent()
                // TODO: pass in values here; see ScheduleNotificationView for where the values will be displayed
                content.title = "Reminder: Meeting"
                content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod())
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
        } else if ev.meetingOrAssessment() == "Assessment"{
            Button(action: {
                ev.hasNotification = true
                // *** Schedule Assessment Notification ***
                let content = UNMutableNotificationContent()
                // TODO: pass in values here; see ScheduleNotificationView for where the values will be displayed
                content.title = "Reminder: Assessment"
                content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod())
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
                ev.hasNotification = true
                // *** Schedule Assessment Notification ***
                let content = UNMutableNotificationContent()
                // TODO: pass in values here; see ScheduleNotificationView for where the values will be displayed
                content.title = "Reminder: Event"
                content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod())
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
        Text("e")
        //EventView(ev: blockEvent(0, DateComponents(calendar: Calendar.current), "000000", "Nall", true, false))
    }
}
