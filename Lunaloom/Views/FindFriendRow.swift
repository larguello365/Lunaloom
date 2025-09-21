//
//  FindFriendRow.swift
//  Lunaloom
//
//  Created by Lester Arguello on 6/1/25.
//

import SwiftUI

struct FindFriendRow: View {
    let social: Social
    let onAddFriend: (String) -> Void
    
    var body: some View {
        HStack {
            // Left: Owl icon is colored if moodLevel > 50, else grayed
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
            
            // Middle: First 5 chars of the user’s ID
            Text(String(social.userId.prefix(5)))
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 8)
            
            Spacer()
            
            Button(action: {
                onAddFriend(social.userId)
            }) {
                Image(systemName: "person.badge.plus")
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
