//
//  Bundle+appsFlyer.swift
//  testAppsFlyer
//
//  Created by Анисимов Алексей Викторович on 26.02.2024.
//

import Foundation

extension Bundle {
    var afPreferences: (devKey: String, appId: String)? {
        guard
            let propertiesPath = Bundle.main.path(forResource: "afdevkey", ofType: "plist"),
            let properties = NSDictionary(contentsOfFile: propertiesPath) as? [String: String],
            let appsFlyerDevKey = properties["appsFlyerDevKey"],
            let appleAppID = properties["appleAppID"]
        else { return nil }

        return (appsFlyerDevKey, appleAppID)
    }
}
