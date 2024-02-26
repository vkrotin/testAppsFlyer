//
//  AppDelegate.swift
//  testAppsFlyer
//
//  Created by Анисимов Алексей Викторович on 22.02.2024.
//

import AppsFlyerLib
import AppTrackingTransparency
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var becomeActiveToken: NotificationToken?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeAppsFlyer()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

//MARK: - AppsFlyer Initialize
extension AppDelegate {
    private func initializeAppsFlyer() {
        guard let afPreferences = Bundle.main.afPreferences else {
            print("[AFSDK] Valid preferences not found, check afdevkey.plist")
            return
        }

        AppsFlyerLib.shared().isDebug = true
        AppsFlyerLib.shared().appsFlyerDevKey = afPreferences.devKey
        AppsFlyerLib.shared().appleAppID = afPreferences.appId
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60) // unrecognized selector !!!
        AppsFlyerLib.shared().deepLinkDelegate = self

        becomeActiveToken = NotificationCenter.default.observe(
            name: UIApplication.didBecomeActiveNotification
        ) { [weak self] _ in
            self?.didBecomeActiveNotification()
        }
    }

    private func didBecomeActiveNotification() {
        AppsFlyerLib.shared().start()
        ATTrackingManager.requestTrackingAuthorization { _ in }
    }
}

//MARK: - DeepLinkDelegate
extension AppDelegate: DeepLinkDelegate {
    func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .found:
            print("[AFSDK] Deep link found")
        case .notFound:
            print("[AFSDK] Deep link not found")
        case .failure:
            print("Error: \(result.error?.localizedDescription ?? "")")
        }
    }
}

