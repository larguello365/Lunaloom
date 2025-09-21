//
//  ContentView.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/9/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var showRatingOverlay = false
    @AppStorage("launchCount") private var launchCount: Int = 0
    @Environment(AuthController.self) private var authController
    
    var body: some View {
        Group {
            switch authController.authState {
            case .undefined:
                ProgressView()
            case .notAuthenticated:
                AuthView()
            case .authenticated:
                MainTabView()
                    .onAppear {
                        if launchCount == 3 { // Show overlay only on 3rd launch
                            showRatingOverlay = true
                        }
                        
                        let groupDefaults = UserDefaults(suiteName: "group.Lunaloom")
                        groupDefaults?.set(authController.userId, forKey: "userId")
                        
                        updateSleepData()
                    }
                    .overlay(
                        showRatingOverlay ? RatingOverlay(isPresented: $showRatingOverlay) : nil
                    )
            }
        }
    }
    
    func updateSleepData() {
        let userId = authController.userId
        let groupDefaults = UserDefaults(suiteName: "group.Lunaloom")
        let dateKey = "\(userId)_lastSleepDate"
        guard let dateString = groupDefaults?.string(forKey: dateKey) else {
            return
        }
        let remKey  = "\(userId)_\(dateString)_rem"
        let coreKey = "\(userId)_\(dateString)_core"
        let deepKey = "\(userId)_\(dateString)_deep"
        
        let remMinutes  = groupDefaults?.integer(forKey: remKey)  ?? 0
        let coreMinutes = groupDefaults?.integer(forKey: coreKey) ?? 0
        let deepMinutes = groupDefaults?.integer(forKey: deepKey) ?? 0
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let sleepDate = formatter.date(from: dateString) else {
            print("Could not parse date string: \(dateString)")
            return
        }
        
        let newSleep = Sleep(
            remTime: remMinutes,
            coreSleepTime: coreMinutes,
            deepSleepTime: deepMinutes,
            date: sleepDate
        )
        
        let db = Firestore.firestore()
        do {
            _ = try db
                .collection("users")
                .document(userId)
                .collection("sleep")
                .addDocument(from: newSleep)
            
            groupDefaults?.removeObject(forKey: remKey)
            groupDefaults?.removeObject(forKey: coreKey)
            groupDefaults?.removeObject(forKey: deepKey)
            groupDefaults?.removeObject(forKey: dateKey)
            
            print("Successfully uploaded sleep data for \(dateString).")
        } catch {
            print("Error writing Sleep document: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let authController = AuthController()
    ContentView()
        .environment(authController)
}
