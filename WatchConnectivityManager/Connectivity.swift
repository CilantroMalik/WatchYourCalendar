//
//  Connectivity.swift
//  CalendarTest
//
//  Created by Rohan Malik on 4/20/22.
//

import Foundation
import WatchConnectivity

final class Connectivity: NSObject, ObservableObject {
    static let shared = Connectivity()
    @Published var data: [String: Any] = [:]
    
    override private init() {
        super.init()
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
        print("Activating Watch Connectivity session")
    }
    
    public func send(obj: [String: Any]) {
        guard WCSession.default.activationState == .activated else { return }
        #if os(watchOS)
            guard WCSession.default.isCompanionAppInstalled else { return }
        #else
            guard WCSession.default.isWatchAppInstalled else { return }
        #endif
        WCSession.default.transferUserInfo(obj)
        print("Initiated data transfer to watch")
    }
}


extension Connectivity: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        self.data = userInfo
        print("Setting data from session: \(self.data)")
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }

    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    #endif
}
