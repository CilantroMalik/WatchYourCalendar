//
//  EventView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 2/15/22.
//

import SwiftUI
import UserNotifications

struct EventView: View {
    var ev : blockEvent
    
    func nEv() -> Int {
        return eventsList[ev.time.month!-1][ev.time.day!]!.count
    }
    
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
            //FIXME: delete event from list >(rohan) should work now? this is kind of hacky but try
            eventsList[ev.time.month!-1][ev.time.day!] = eventsList[ev.time.month!-1][ev.time.day!]!.filter { !($0.isEqual(ev)) }
        }, label: {Text("Delete Event").fontWeight(.heavy).multilineTextAlignment(.center)})
        //TODO: edit events' labels (for appearance in MidView and for notifications)
        if !ev.hasNotification { //so the button disappears after scheduling notifications
            if ev.meetingOrAssessment() == "Meeting" {
                Button(action: {
                    ev.hasNotification = true
                    // *** Schedule Meeting Notification ***
                    let content = UNMutableNotificationContent()
                    // TOD: pass in values here; see ScheduleNotificationView for where the values will be displayed
                    content.title = "Reminder: Meeting"
                    content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod())
                    content.sound = UNNotificationSound.default
                    content.body = "Reminder: You have a meeting this block."
                    content.categoryIdentifier = "event"
                    
                    // TOD: use the cycle day and block instance variables, as well as any methods we have, to calculate the components for the date that we need to trigger the notification
                    // TODO: >(rohan) fun puzzle for you to figure out — exactly how do we calculate the exact time to display the notification? we have all the methods...
                    // (then replicate in the other two fields, below
                    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: false)

                    // TOD: somehow construct a unique identifier string from the date and class or block information; do it in such a way as to ensure that any other meeting we schedule into some other block cannot possibly have the same string
                    let request = UNNotificationRequest(identifier: "\(ev.toString())-\(nEv()+1)", content: content, trigger: trigger)

                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                }, label: { Text("Be notified!").fontWeight(.medium) })
            } else if ev.meetingOrAssessment() == "Assessment"{
                Button(action: {
                    ev.hasNotification = true
                    // *** Schedule Assessment Notification ***
                    let content = UNMutableNotificationContent()
                    // TOD: pass in values here; see ScheduleNotificationView for where the values will be displayed
                    content.title = "Reminder: Assessment"
                    content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod())
                    content.sound = UNNotificationSound.default
                    content.body = "Reminder: You have an assessment this block. Good luck!"
                    content.categoryIdentifier = "event"
                    
                    // TOO: use the cycle day and block instance variables, as well as any methods we have, to calculate the components for the date that we need to trigger the notification
                    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: false)

                    // ODO: somehow construct a unique identifier string from the date and class or block information; do it in such a way as to ensure that any other assessment we schedule into some other block cannot possibly have the same string
                    let request = UNNotificationRequest(identifier: "\(ev.toString())-\(nEv()+1)", content: content, trigger: trigger)

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
                    
                    // ODO: use the cycle day and block instance variables, as well as any methods we have, to calculate the components for the date that we need to trigger the notification
                    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: false)

                    // OO: somehow construct a unique identifier string from the date and class or block information; do it in such a way as to ensure that any other assessment we schedule into some other block cannot possibly have the same string
                    let request = UNNotificationRequest(identifier: "\(ev.toString())-\(nEv()+1)", content: content, trigger: trigger)

                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                }, label: { Text("Be notified!").fontWeight(.medium) })
            }
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        Text("e")
    }
}
