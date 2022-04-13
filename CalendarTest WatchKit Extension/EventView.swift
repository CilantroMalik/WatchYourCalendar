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
                Button(action: {
                    for i in 1...EventsListObs.evList[ev.time.month!-1][ev.time.day!]!.count { //TODO: check if this is right?
                        if EventsListObs.evList[ev.time.month!-1][ev.time.day!]![i-1].isEqual(ev) { /*I changed i to i-1*/ EventsListObs.evList[ev.time.month!-1][ev.time.day!]![i-1].hasNotification = true }
                    }
                    // *** Schedule Meeting Notification ***
                    let content = UNMutableNotificationContent()
                    // TOD: pass in values here; see ScheduleNotificationView for where the values will be displayed
                    content.title = "Reminder: " + ev.meetingOrAssessment()
                    content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod() + "\n" + ev.label)
                    content.sound = UNNotificationSound.default
                    var detail = ev.label.split(separator: " ")
                    detail.removeLast()
                    detail.removeLast()
                    if ev.meetingOrAssessment() == "Meeting" {
                        content.body = "Reminder: You have a meeting during the \(detail.joined(separator: " ")) of the block."
                        if detail.joined(separator: " ") == "entirety" { content.body = "Reminder: You have a meeting for the whole block." }
                    } else {
                        content.body = "Reminder: You have an assessment (a \(detail.joined(separator: " ").lowercased()) this block."
                    }
                    content.categoryIdentifier = "event"
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, month: ev.time.month, day: ev.time.day, hour: getBlockAlmostStartTimes(ev.block).hour, minute: getBlockAlmostStartTimes(ev.block).minute), repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "\(ev.toString())-\(nEv()+1)", content: content, trigger: trigger)
                    
                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                    presentationMode.wrappedValue.dismiss()
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
