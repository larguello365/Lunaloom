//
//  SplashScreen.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/9/25.
//

import SwiftUI

/*
 A feature row represents the an HStack with
 each tab icon and a description of that tab's
 function.
 */

struct FeatureRow: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.yellow)
            Text(text)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
        }
    }
}

/*
 Splash screen as seen by user when the app is
 loaded.
 */
struct SplashScreen: View {
    @Binding var isActive: Bool
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                                       startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Image("owl")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .shadow(radius: 5)
                Text("Welcome to Lunaloom!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.yellow)
                    .shadow(radius: 2)
                    .padding(.top, 10)
                VStack(alignment: .leading, spacing: 15) {
                    FeatureRow(icon: "house.fill", text: "Use the home menu to track your sleep and feed Nyxie!")
                    FeatureRow(icon: "chart.xyaxis.line", text: "Review and track your sleep data from your previous sessions.")
                    FeatureRow(icon: "lightbulb.max.fill", text: "Read tips on how to improve your sleep quality.")
                }
                .padding(.horizontal)
                Text("Developed by Lester Arguello")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .shadow(radius: 2)
                    .padding(.top, 10)
                Spacer()
                Button(action: {
                    withAnimation {
                        isActive = false
                    }
                    print("Going to home screen")
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    SplashScreen(isActive: .constant(true))
}
