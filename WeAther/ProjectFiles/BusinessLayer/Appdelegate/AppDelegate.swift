//
//  AppDelegate.swift
//  WeAther
//
//  Created by PC-010 on 25/03/22.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@main
/// This class is supposed to be there to handle application lifecycle events - i.e.,
/// responding to the app being launched, backgrounded, foregrounded, receiving data, and so on
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// Window in which the application is being executed.
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

// MARK: - Private methods
private extension AppDelegate {
    func checkNetworkConnection() {
        Reachability.shared.startMonitoring { status in
            switch status {
            case .requiresConnection, .unsatisfied:
                print(status)
            case .satisfied:
                print(status)
            @unknown default:
                break
            }
        }
    }
    func setUpKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}
