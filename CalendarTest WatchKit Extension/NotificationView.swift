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
//    func getEvArr() -> [blockEvent] {
//        var date = Date()
//        let cal = Calendar.current
//        if globalOffset != 0 {
//            date = cal.date(byAdding: .day, value: globalOffset, to: date)!
//        }
//        let dtcp = DateComponents(calendar: Calendar.current, month: cal.component(.month, from: date), day: cal.component(.day, from: date))
//        let events = eventsList[dtcp.month! - 1][dtcp.day!]!
//        return events
//    }
//    func eventsToday() -> String {
//        let date = Date()
//        let cal = Calendar.current
//        let datecomp = DateComponents(calendar: cal)
//        if cycleDay == 0 { return "No events!" }
//        return "Events today:\n" + (getEvArr()[0...(getEvArr().count)]).joined(separator: "\n")//FIXME: i am trying to add events to the daily summary
//    }
//    func hasSports() -> Bool {
////        return cycleDay == 3 || cycleDay == 6 || cycleDay == 8
//    }
    
    var body: some View {
        Text("Day \(cycleDay): \(compGetOrder())").font(.system(size: 20)).fontWeight(.black)
//        if hasSports() {
//            Text("Sports today!").font(.title3).fontWeight(.semibold).foregroundColor(.orange)
//        } else {
//            Text("No sports today.").font(.title3).fontWeight(.light)
//        }
        Divider()
        Text(classesToday()).multilineTextAlignment(.center).font(.system(size: 12)).frame(width: nil, height: cycleDay == 0 ? 20 : 100, alignment: .center)
//        Divider()
//        Text(eventsToday()).multilineTextAlignment(.center).font(.system(size: 12)).frame(width: nil, height: cycleDay == 0 ? 20 : 100, alignment: .center)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(content: UNNotificationContent())
    }
}
