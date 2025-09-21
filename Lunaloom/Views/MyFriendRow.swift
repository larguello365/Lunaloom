//
//  MyFriendRow.swift
//  Lunaloom
//
//  Created by Lester Arguello on 6/1/25.
//

import SwiftUI

struct MyFriendRow: View {
    let social: Social
    let onGiveSeed: (String) -> Void
    
    var body: some View {
        HStack {
            if social.moodLevel > 50 {
                Image("owl")
                    .resizable()
                    .scaledToFit()
                    .frame(width:40, height: 40)
                    .shadow(radius: 2)
            } else {
                Image("redOwl")
                    .resizable()
                    .scaledToFit()
                    .frame(width:40, height: 40)
                    .shadow(radius: 2)
            }
            
            Text(String(social.userId.prefix(5)))
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 8)
            
            Spacer()
            
            Button(action: {
                onGiveSeed(social.userId)
            }) {
                Image(systemName: "gift.fill")
                    .foregroundColor(.yellow)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
        .background(Color.clear)
    }
}
