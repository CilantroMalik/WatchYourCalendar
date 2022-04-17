//
//  NotificationView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI
import UserNotifications

struct NotificationView: View {
    
    var content: UNNotificationContent
    
    func classesToday() -> String {
        if cycleDay == 0 { return "No classes!" }
        let classes = classes[cycleDay]!
        return "Classes today:\n" + classes[0...4].joined(separator: "\n")
    }
    func eventsToday() -> [blockEvent] {
        let date = Date()
        let cal = Calendar.current
        let datecomp = DateComponents(calendar: Calendar.current, month: cal.component(.month, from: date), day: cal.component(.day, from: date))
        let dayEvents = EventsListObs.evList[datecomp.month! - 1][datecomp.day!]!
        var blockEvents: [blockEvent] = []
        for event in dayEvents {
            blockEvents.append(event)
        }
        return blockEvents
    }
    func getEventsToday() -> String {
        var evs: [String] = []
        var c: Int = 0
            for item in eventsToday() {
                evs.append(item.label + ": " + getClassess(day: cycleDay, block: item.block))
                c += 1
            }
        c -= 1
        return "Events today:\n" + evs[0...c].joined(separator: "\n")
    }
    func getEventsLength() -> Int {
        var i: Int = 20
        for item in eventsToday() {
            if item == item{
            i += 15
            }
        }
        return i
//        return 30
    }
//    func hasSports() -> Bool {
//        return cycleDay == 3 || cycleDay == 6 || cycleDay == 8
//    }
    
    var body: some View {
        Text("Day \(cycleDay): \(compGetOrder())").font(.system(size: 20)).fontWeight(.black)
//        if hasSports() {
//            Text("Sports today!").font(.title3).fontWeight(.semibold).foregroundColor(.orange)
//        } else {
//            Text("No sports today.").font(.title3).fontWeight(.light)
//        }
        Divider()
        Text(classesToday()).multilineTextAlignment(.center).font(.system(size: 12)).frame(width: nil, height: cycleDay == 0 ? 50 : 100, alignment: .center)
        if !eventsToday().isEmpty {
            Divider()
            Text(getEventsToday()).multilineTextAlignment(.center).font(.system(size: 12)).frame(width: nil, height: cycleDay == 0 ? CGFloat(getEventsLength()) : CGFloat(getEventsLength()), alignment: .center)}
}
}
struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(content: UNNotificationContent())
    }
}
