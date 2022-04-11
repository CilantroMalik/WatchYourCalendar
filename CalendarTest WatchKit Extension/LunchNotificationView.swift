//
//  LunchNotificationView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Rohan Malik on 2/5/22.
//

import SwiftUI
import UserNotifications

struct LunchNotificationView: View {
    
    // don't really need to use this but it's here anyway
    var content: UNNotificationContent
    func postLunchClass() -> String{
        return classes[cycleDay]![3]
    }
    var body: some View {
        // populate with some text
        Text("10 minutes until lunch ends!")
        Text("Your next class is\n")
        Text(postLunchClass()).multilineTextAlignment(.center).font(.system(size: 24)).frame(width: nil, height: cycleDay == 0 ? 20 : 100, alignment: .center)
    }
}

struct LunchNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        LunchNotificationView(content: UNNotificationContent())
    }
}
