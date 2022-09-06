//
//  ContentView.swift
//  WatchYourCalendar
//
//  Created by us on 4/20/22.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    
    var body: some View {
        TabView {
            RichDayView().tabItem { Label("Home", systemImage: "house.fill") }
            WatchConfig().tabItem { Label("Config", systemImage: "gearshape.fill") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
