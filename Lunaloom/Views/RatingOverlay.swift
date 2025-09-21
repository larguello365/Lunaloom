//
//  RatingOverlay.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/12/25.
//

import SwiftUI

struct RatingOverlay: View {
    @Binding var isPresented: Bool
    @AppStorage("launchCount") private var launchCount: Int = 0
    
    var body: some View {
        VStack {
            Text("Enjoying Lunaloom?")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Rate us on the App Store and help us improve!")
                .multilineTextAlignment(.center)
                .padding()
            
            HStack {
                Button("Not Now") {
                    isPresented = false
                }
                .padding()
                
                Button("Rate Now") {
                    isPresented = false
                    // Open App Store URL (Replace with your App's link)
                    if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
                        UIApplication.shared.open(url)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
        .shadow(radius: 5)
        .frame(maxWidth: 300)
    }
}

#Preview {
    RatingOverlay(isPresented: .constant(true))
}
