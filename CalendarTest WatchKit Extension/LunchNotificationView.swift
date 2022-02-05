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
    
    var body: some View {
        // populate with some text
        Text("lunch almost over!")
    }
}

struct LunchNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        LunchNotificationView(content: UNNotificationContent())
    }
}
