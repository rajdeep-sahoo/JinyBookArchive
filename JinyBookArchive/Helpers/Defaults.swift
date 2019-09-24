//
//  Defaults.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import UIKit

class Default {

    private enum DefaultString: String {
        case isListFiltered
    }
    
    static let shared = Default()
    
    var isListFiltered: Bool {
        get {
            return UserDefaults.standard.bool(forKey: DefaultString.isListFiltered.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: DefaultString.isListFiltered.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
}

