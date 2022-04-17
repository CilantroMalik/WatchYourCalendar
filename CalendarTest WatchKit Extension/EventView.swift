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
            Text("Event Details").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 3)
            if ev.hasLabel {Text(ev.label).fontWeight(.heavy).foregroundColor(.orange)}
            Text(getOffsetDate())
            Text("Day \(ev.getDay()), \(ev.getPeriod())")
            Text(ev.getTime())
            if ev.getRoom() != "e" {Text(ev.getRoom())}

            Divider().padding(.vertical, 5)
            Text("Options:").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
            Button(action: {
                eventsListObs.delEvent(ev: ev)
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [ev.toString()])
                presentationMode.wrappedValue.dismiss()
            }, label: {Text("Delete Event").fontWeight(.heavy).multilineTextAlignment(.center)})
            if !ev.hasNotification { //so the button disappears after scheduling notifications
                Button(action: {
                    for i in 1...EventsListObs.evList[ev.time.month!-1][ev.time.day!]!.count {
                        if EventsListObs.evList[ev.time.month!-1][ev.time.day!]![i-1].isEqual(ev) { EventsListObs.evList[ev.time.month!-1][ev.time.day!]![i-1].hasNotification = true }
                    }
                    // *** Schedule Meeting Notification ***
                    let content = UNMutableNotificationContent()
                    content.title = "Reminder: " + ev.meetingOrAssessment()
                    content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod() + "\n" + ev.label)
                    content.sound = UNNotificationSound.default
                    if #available(watchOSApplicationExtension 8.0, *) {
                        content.interruptionLevel = .timeSensitive
                    }
                    var detail = ev.label.split(separator: " ")
                    detail.removeLast()
                    detail.removeLast()
                    if ev.meetingOrAssessment() == "Assessment" {
                        content.body = "Reminder: You have a \(detail.joined(separator: " ").lowercased()) this block."
                    } else {
                        content.body = "Reminder: You have a \(ev.meetingOrAssessment().lowercased()) during the \(detail.joined(separator: " "))."
                        if detail.joined(separator: " ") == "entirety" { content.body = "Reminder: You have a meeting for the entire block." }
                    }
                    content.categoryIdentifier = "event"
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, month: ev.time.month!, day: ev.time.day!, hour: getBlockAlmostStartTimes(ev.block).hour, minute: getBlockAlmostStartTimes(ev.block).minute), repeats: false)

                    let request = UNNotificationRequest(identifier: ev.toString(), content: content, trigger: trigger)
                    
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
        Text("e").foregroundColor(.purple)
    }
}
