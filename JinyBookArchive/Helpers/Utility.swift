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
import Kingfisher
import DropDown

final class Utility {
    
    private init() {}
    
    static let shared = Utility()
    
    // MARK: - Local Constants
    let window = UIApplication.shared.windows.last!
    var delegate: FilterOptionDelegate?
    
    // MARK: - Drop Down Helper
    func dropDownUI() -> DropDown {
        let dropDown = DropDown()
        dropDown.cellHeight = 40
        dropDown.textColor = UIColor(rgb: TEXT_BLACK_COLOR)
        dropDown.backgroundColor = UIColor(rgb: BACKGROUND_COLOR)
        return dropDown
    }
    
    func addWhiteSpaceToDropDown(dataSource: [String]) -> [String] {
        return dataSource.map { "  " + $0 }
    }
    
    func dropDown(on view: UIBarButtonItem, from viewController: UIViewController) {
        let dropDown = dropDownUI()
        let leftPadding = "    "
        dropDown.anchorView = view
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! + 2)
        dropDown.width = 150
        
        dropDown.dataSource = [leftPadding + AUTHOR, leftPadding + GENRE, leftPadding + COUNTRY, leftPadding + NO_FILTER]
        
        dropDown.selectionAction = { (index: Int, item: String) in
            switch item.trimmingCharacters(in: .whitespaces) {
                
            case AUTHOR:
                self.delegate?.filterOptionSelected(type: .Author)
                
            case GENRE:
                self.delegate?.filterOptionSelected(type: .Genre)
                
            case COUNTRY:
                self.delegate?.filterOptionSelected(type: .Country)
                
            case NO_FILTER:
                self.delegate?.filterOptionSelected(type: .NoFilter)
                
            default:
                break
            }
        }
        dropDown.show()
    }
    
    
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
    
    
    // MARK: - Image View Helper
    func setImage(from urlOfImage: String, on imageView: UIImageView) {
        guard let url = URL(string: urlOfImage) else { return }
        imageView.kf.setImage(
            with: url,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5)),
                .cacheOriginalImage
            ]
        )
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
