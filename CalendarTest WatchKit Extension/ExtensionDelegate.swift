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
        let category1 = UNNotificationCategory(identifier: "sports", actions: [], intentIdentifiers: [], options: [])
        let category2 = UNNotificationCategory(identifier: "lunch", actions: [], intentIdentifiers: [], options: [])
        let category3 = UNNotificationCategory(identifier: "event", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category1, category2, category3])
        
        scheduleSportsNotification()
        scheduleLunchNotification()
        let ud = UserDefaults.standard
        guard let temp = ud.stringArray(forKey: "eventsList") else { return }
        print("-- Before --")
        print(EventsListObs.evList)
        print("-- Temp -- ")
        print(temp)
        for str in temp {
            let comps = str.split(separator: "-")
            print("- Comps -")
            print(comps)
            print("- Block Event -")
            print(blockEvent(String(comps[2])).toString())
            EventsListObs.evList[Int(String(comps[0]))!][Int(String(comps[1]))!]?.append(blockEvent(String(comps[2])))
        }
        print("-- After --")
        print(EventsListObs.evList)
        
        guard let temp = ud.array(forKey: "firstLunch") else { return }
        temp = temp as! [Bool]
        for i in 0...7 {
            lunchBlockFirst[i+1] = [temp[i]]
        }
        guard let temp = ud.stringArray(forKey: "classes") else { return }
        let (a, b, c, d, e, f, g, h) = temp
        classes[1] = [c, e, d, a, b, "Sports/Go Home"]
        classes[2] = [f, g, h, a, b, "Sports/Go Home"]
        classes[3] = [c, d, f, e, g, "Sports/Go Home"]
        classes[4] = [h, a, b, c, d, "Sports/Go Home"]
        classes[5] = [g, a, h, e, f, "Sports/Go Home"]
        classes[6] = [b, c, d, e, f, "Sports/Go Home"]
        classes[7] = [a, h, g, b, c, "Sports/Go Home"]
        classes[8] = [d, e, f, g, h, "Sports/Go Home"]
        
        let userData = UserData()
        userData.updateClasses(classes)
        userData.updateLunch(lunchBlockFirst)
    }
    
    func applicationWillResignActive() {
        let ud = UserDefaults.standard
        var allEvents: [String] = []
        for (i, month) in (EventsListObs.evList).enumerated() {
            for key in month.keys {
                for event in month[key]! {
                    allEvents.append("\(i)-\(key)-\(event.toString())")
                }
            }
        }
        print(allEvents)
        ud.set(allEvents, forKey: "eventsList")
    }
}
