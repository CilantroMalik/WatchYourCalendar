//
//  WatchYourCalendarApp.swift
//  WatchYourCalendar
//
//  Created by Jack de Haan on 4/20/22.
//

import SwiftUI

@main
struct WatchYourCalendarApp: App {
    init() {
        print("initializing")
        let ud = UserDefaults.standard
        guard let temp = ud.array(forKey: "ZLunch") else { return }
        for i in 0...5 {
            ZLunch[i+1] = (temp[i] as! Int)
        }
        guard let temp = ud.stringArray(forKey: "classes") else { return }
        let a = temp[0]
        let b = temp[1]
        let c = temp[2]
        let d = temp[3]
        let e = temp[4]
        let f = temp[5]
        let g = temp[6]
        let h = temp[7]
        let z1 = temp[8]
        let z2 = temp[9]
        classes[1] = [a, b, c, z1, z2, d]
        classes[2] = [e, f, g, z1, z2, h]
        classes[3] = [d, a, b, z1, z2, c]
        classes[4] = [h, e, f, z1, z2, g]
        classes[5] = [c, d, a, z1, z2, b]
        classes[6] = [g, h, e, z1, z2, f]
        guard let temp = ud.stringArray(forKey: "sports") else { return }
        for i in 0...5 {
            sports[i] = temp[i]
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success { print("All set!") }
            else if let error = error { print(error.localizedDescription) }
        }
        
        UISegmentedControl.appearance().apportionsSegmentWidthsByContent = true
        
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
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
