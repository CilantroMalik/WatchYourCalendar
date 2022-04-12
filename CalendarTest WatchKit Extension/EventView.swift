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
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var eventsListObs = EventsListObs()
    
    func nEv() -> Int {
        return EventsListObs.evList[ev.time.month!-1][ev.time.day!]!.count
    }
    
    var body: some View {
        ScrollView{
            Text("Event Details").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
            Text(getOffsetDate())
            Text("Day \(ev.getDay()), \(ev.getPeriod())")
            if ev.getRoom() != "e" {Text(ev.getRoom())}
            if ev.hasLabel {Text(ev.label)}
            Divider().padding(.vertical, 5)
            Text("Options:").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
            Button(action: {
                eventsListObs.delEvent(ev: ev)
                presentationMode.wrappedValue.dismiss()
            }, label: {Text("Delete Event").fontWeight(.heavy).multilineTextAlignment(.center)})
            if !ev.hasNotification { //so the button disappears after scheduling notifications
                if ev.meetingOrAssessment() == "Meeting" {
                    Button(action: {
                        ev.hasNotification = true
                        // *** Schedule Meeting Notification ***
                        let content = UNMutableNotificationContent()
                        // TOD: pass in values here; see ScheduleNotificationView for where the values will be displayed
                        content.title = "Reminder: Meeting"
                        content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod() + "\n" + ev.label)
                        content.sound = UNNotificationSound.default
                        var detail = ev.label.split(separator: " ")
                        detail.removeLast()
                        content.body = "Reminder: You have a meeting during the \(detail.joined(separator: " ")) of the block."
                        content.categoryIdentifier = "event"
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, month: ev.time.month, day: ev.time.day, hour: getBlockAlmostStartTimes(ev.block).hour, minute: getBlockAlmostStartTimes(ev.block).minute), repeats: false)
                        
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
                        content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod() + "\n" + ev.label)
                        content.sound = UNNotificationSound.defaultCritical
                        content.body = "Reminder: You have an assessment this block. Good luck!"
                        content.categoryIdentifier = "event"
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, month: ev.time.month, day: ev.time.day, hour: getBlockAlmostStartTimes(ev.block).hour, minute: getBlockAlmostStartTimes(ev.block).minute), repeats: false)
                        
                        let request = UNNotificationRequest(identifier: "\(ev.toString())-\(nEv()+1)", content: content, trigger: trigger)
                        
                        // add our notification request
                        UNUserNotificationCenter.current().add(request)
                    }, label: { Text("Be notified!").fontWeight(.medium) })
                } else {
                    Button(action: {
                        ev.hasNotification = true
                        // *** Schedule Event Notification ***
                        let content = UNMutableNotificationContent()
                        content.title = "Reminder: Event"
                        content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod() + "\n" + ev.label)
                        content.sound = UNNotificationSound.default
                        var detail = ev.label.split(separator: " ")
                        detail.removeLast()
                        content.body = "Reminder: You have an event during the \(detail.joined(separator: " ")) of the block."
                        content.categoryIdentifier = "event"
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, month: ev.time.month, day: ev.time.day, hour: getBlockAlmostStartTimes(ev.block).hour, minute: getBlockAlmostStartTimes(ev.block).minute), repeats: false)
                        
                        let request = UNNotificationRequest(identifier: "\(ev.toString())-\(nEv()+1)", content: content, trigger: trigger)
                        
                        // add our notification request
                        UNUserNotificationCenter.current().add(request)
                    }, label: { Text("Be notified!").fontWeight(.medium) })
                }
            }
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        Text("e")
    }
}
