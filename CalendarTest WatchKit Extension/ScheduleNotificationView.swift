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
        Text(content.title).font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
        Text(content.subtitle).font(.title3).fontWeight(.medium)
        Divider()
        Text(content.body).multilineTextAlignment(.center).font(.system(size: 12)).frame(width: nil, height: cycleDay == 0 ? 20 : 50, alignment: .center)
    }
}

struct ScheduleNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleNotificationView(content: UNNotificationContent())
    }
}
