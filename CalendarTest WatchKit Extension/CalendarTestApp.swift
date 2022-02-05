//
//  CalendarTestApp.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI
import WatchKit

@main
struct CalendarTestApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "sports")
        WKNotificationScene(controller: LunchNotificationController.self, category: "lunch")
    }
}
