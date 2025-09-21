//
//  SettingsView.swift
//  Lunaloom
//
//  Created by Lester Arguello on 5/31/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AuthController.self) private var authController
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Logout button
                Button(action: {
                    // Call your sign-out logic here
                    authController.signOut()
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Settings")
    }
}


#Preview {
    let authController = AuthController()
    SettingsView()
        .environment(authController)
}
