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
    
    func getEventLabel(_ lbl: String) -> String {
        if (lbl.contains(";")) {
            return String(lbl.split(separator: ";")[1])
        } else {
            return lbl
        }
    }
    
    var body: some View {
        ScrollView{
            Text("Event Details").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 2)
            Group{
                if ev.hasLabel {Text(getEventLabel(ev.label)).fontWeight(.heavy).foregroundColor(.orange)}
                Text("Day \(ev.getDay()), \(ev.getPeriod())").multilineTextAlignment(.center)
                Text(ev.getTime(label: getEventLabel(ev.label))).multilineTextAlignment(.center)
                if ev.getRoom() != "e" {Text(ev.getRoom()).italic().multilineTextAlignment(.center)}
                Text(getOffsetDate()).italic().multilineTextAlignment(.center)
                ev.hasNotification ?  Text("Notifications on").fontWeight(.heavy) : Text("Notifications off").italic().foregroundColor(Color(UIColor.lightGray))
            }
            Divider().padding(.vertical, 5)
            Text("Options:").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
            Button(action: {
                eventsListObs.delEvent(ev: ev)
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [ev.toString()])
                presentationMode.wrappedValue.dismiss()
            }, label: {Text("Delete Event").fontWeight(.heavy).multilineTextAlignment(.center)})
            if !ev.hasNotification {
                Button(action: {
                    for i in 1...EventsListObs.evList[ev.time.month!-1][ev.time.day!]!.count {
                        if EventsListObs.evList[ev.time.month!-1][ev.time.day!]![i-1].isEqual(ev) {
                            EventsListObs.evList[ev.time.month!-1][ev.time.day!]![i-1].hasNotification = true
                            Connectivity.shared.send(obj: ["eventsList": EventsListObs.evList])
                        }
                    }
                    // *** Schedule Meeting Notification ***
                    let content = UNMutableNotificationContent()
                    var detail = ev.label.contains(";") ? String(ev.label.split(separator: ";")[0]).split(separator: " ") : ev.label.split(separator: " ")
                    detail.removeLast()
                    detail.removeLast()
                    if ev.meetingOrAssessment() == "Assessment" {
                        if (ev.label.contains(";")) { content.title = ("Reminder: " + String(String(ev.label.split(separator: ";")[0]).split(separator: " ")[0]) + " (\(String(ev.label.split(separator: ";")[1])))") }
                        else { content.title = "Reminder: " + String(ev.label.split(separator: " ")[0]) }
                    } else { content.title = "Reminder: Meeting" }
                    if ev.getRoom() != "e" {
                        content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod() + "; " + ev.getTime(label: getEventLabel(ev.label)) + "; " + ev.getRoom())
                    } else {
                        content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod() + "; " + ev.getTime(label: getEventLabel(ev.label)))
                    }
                    content.sound = UNNotificationSound.default
                    if #available(watchOSApplicationExtension 8.0, *) {
                        content.interruptionLevel = .timeSensitive
                    }
                    
                    if ev.meetingOrAssessment() == "Assessment" {
                        content.body = "Reminder: You have a \(String(ev.label.split(separator: " ")[0]).lowercased()) this block. Good luck!"
                    } else {
                        content.body = "Reminder: You have a meeting during the \(String(ev.label.split(separator: "#")[0]).lowercased())of the block."
                        if String(ev.label.split(separator: " ")[0]).lowercased() == "entire" { content.body = "Reminder: You have a meeting for the entire block." }
                    }
                    content.categoryIdentifier = "event"
                    
                    // let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, month: ev.time.month!, day: ev.time.day!, hour: getBlockAlmostStartTimes(ev.block).hour, minute: getBlockAlmostStartTimes(ev.block).minute), repeats: false)
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    
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
