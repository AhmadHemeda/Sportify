import Foundation
import Reachability

class ReachabilityNetworkManager {
    
    var reachability : Reachability!
    
    init(reachability: Reachability!) {
        self.reachability = reachability
    }
    
    func isReachableViaWiFi() -> Bool {
        startReachability()
        
        if reachability.connection == .wifi {
            return true
        } else {
            return false
        }
    }
    
    func startReachability() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            try reachability.startNotifier()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    @objc func reachabilityChanged(_ notification:Notification) {
        
    }
    
}
