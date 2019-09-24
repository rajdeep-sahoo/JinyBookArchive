//
//  Utility.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import UIKit
import SystemConfiguration
import MBProgressHUD

final class Utility {
    
    static let shared = Utility()
    
    // MARK: - Local Constants
    let window = UIApplication.shared.windows.last!
    
    
    // MARK: - MBProgressHUDs
    func showHUDLoader() {
        DispatchQueue.main.async(execute: {
            let loader = MBProgressHUD.showAdded(to: self.window, animated: true)
            loader.mode = MBProgressHUDMode.indeterminate
        })
    }
    
    
    func hideHUDLoader() {
        DispatchQueue.main.async(execute: {
            MBProgressHUD.hide(for: self.window, animated: true)
        })
    }
    
    
    // MARK: - UIAlerts
    func showAlert(withMessage message: String, from viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: APP_NAME, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: OK, style: UIAlertAction.Style.default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Network Helper
    func isInternetAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
        
    }
    
    
}
