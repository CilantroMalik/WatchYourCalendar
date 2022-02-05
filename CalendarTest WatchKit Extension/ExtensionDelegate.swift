//
//  ExtensionDelegate.swift
//  CalendarTest WatchKit Extension
//
//  Created by Rohan Malik on 2/4/22.
//

import Foundation
import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                reloadActiveComplications()
                backgroundTask.setTaskCompletedWithSnapshot(false)
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func applicationDidFinishLaunching() {
        scheduleRefresh()
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { success, error in
            if success { print("Authorized") } else if let error = error { print(error.localizedDescription) }
        }
        scheduleSportsNotification()
        scheduleLunchNotification()
    }
    
}
