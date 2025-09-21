//
//  LunaloomApp.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/9/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    return true
  }
}

@main
struct LunaloomApp: App {
    @AppStorage("launchCount") private var launchCount: Int = 0
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var authController = AuthController()
    
    init() {
        FirebaseApp.configure()
        registerDefaults()
        incrementLaunchCount()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authController)
                .onAppear {
                    authController.listenToAuthChanges()
                }
        }
    }
    
    private func registerDefaults() {
        let defaults = UserDefaults.standard
        
        defaults.register(defaults: [
            "name_preference": "Lester Arguello",
            "enabled_preference": true,
            "slider_preference": 0.6,
        ])
        
        if defaults.object(forKey: "InitialLaunch") == nil {
            defaults.set(Date.now, forKey: "InitialLaunch")
        }
    }
    
    private func incrementLaunchCount() {
        launchCount += 1
    }
}
