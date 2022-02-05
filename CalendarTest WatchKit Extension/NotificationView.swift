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
    
    func hasSports() -> Bool {
        return cycleDay == 3 || cycleDay == 6 || cycleDay == 8
    }
    
    var body: some View {
        Text("Day \(cycleDay): \(compGetOrder())").font(.system(size: 20)).fontWeight(.black)
        if hasSports() {
            Text("Sports today!").font(.title3).fontWeight(.semibold).foregroundColor(.orange)
        } else {
            Text("No sports today.").font(.title3).fontWeight(.light)
        }
        Divider()
        Text(classesToday()).multilineTextAlignment(.center).font(.system(size: 12)).frame(width: nil, height: cycleDay == 0 ? 20 : 100, alignment: .center)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(content: UNNotificationContent())
    }
}
