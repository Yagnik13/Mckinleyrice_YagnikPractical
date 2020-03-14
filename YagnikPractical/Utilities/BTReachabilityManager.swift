//
//  BTReachabilityManager.swift
//  uClinic
//
//  Created by Viral Shah on 21/05/18.
//  Copyright © 2018 Viral Shah. All rights reserved.
//

import Foundation
import Reachability

class BTReachabilityManager: NSObject {
    
    private let reachability = Reachability()!
    private var isFirstTimeSetupDone:Bool = false
    private var callCounter:Int = 0
    
    // MARK: - SHARED MANAGER
    static let shared: BTReachabilityManager = BTReachabilityManager()
    
    
    //MARK:- ALL NETWORK CHECK
    func isInternetAvailableForAllNetworks() -> Bool {
        if(!self.isFirstTimeSetupDone){
            self.isFirstTimeSetupDone = true
            doSetupReachability()
        }
        return reachability.connection == .cellular || reachability.connection == .wifi
    }
    
    
    //MARK:- SETUP
    private func doSetupReachability() {
        
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.postIntenetReachabilityDidChangeNotification(isInternetAvailable: true)
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.postIntenetReachabilityDidChangeNotification(isInternetAvailable: false)
            }
        }
        do{
            try reachability.startNotifier()
        }catch{
        }
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)
    }
    
    
    
    //MARK:- NOTIFICATION
    private func postIntenetReachabilityDidChangeNotification(isInternetAvailable isAvailable:Bool){
        //        print("\n\n")
        //        print("NET REACHABILITY CHANGED : \(isAvailable)")
        NotificationCenter.default.post(NSNotification(name: Notification.Name.reachabilityChanged, object: nil) as Notification)
            
    }
}
