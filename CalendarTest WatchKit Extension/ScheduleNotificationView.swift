//
//  ScheduleNotificationView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 2/5/22.
//

import SwiftUI
import UserNotifications

struct ScheduleNotificationView: View {
    
    var content: UNNotificationContent
    var body: some View {
        Text("You have a " + meetingOrAssessment() + " today during\n")
        Text(classes[cycleDay]![getAssessmentBlock()]).multilineTextAlignment(.center).font(.system(size: 12)).frame(width: nil, height: cycleDay == 0 ? 20 : 100, alignment: .center)
    }
}

struct ScheduleNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleNotificationView(content: UNNotificationContent())
    }
}
