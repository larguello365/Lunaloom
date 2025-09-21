//
//  MainTabView.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/10/25.
//

import SwiftUI

/*
 3-tab tab view that makes up the structure of the
 app. It takes in an additional seed paramater to
 add seeds gained from the sleep overview screen to
 the user's current number of seeds
 */

struct MainTabView: View {
    @Environment(AuthController.self) private var authController
    
    var body: some View {
        TabView {
            HomeView(userId: authController.userId)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            FriendsView()
                .tabItem {
                    Label("Friends", systemImage: "person.3.fill")
                }
            
            SleepTrackingView()
                .tabItem {
                    Label("Sleep Data", systemImage: "chart.xyaxis.line")
                }
            
            TipsView()
                .tabItem {
                    Label("Tips", systemImage: "lightbulb.max.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainTabView()
}
