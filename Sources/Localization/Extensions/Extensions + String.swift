//
//  Extensions + String.swift
//  
//
//  Created by Bohdan on 16.03.2023.
//

import Foundation

public extension String {
    /// Property that returns a localized string given a key.
    var localized: String {
        let bundle: Bundle = .main
        if let path = bundle.path(forResource: LocalizationManager.currentLanguage, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        } else if let path = bundle.path(forResource: "Base", ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }
}
