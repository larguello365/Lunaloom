//
//  Social.swift
//  Lunaloom
//
//  Created by Lester Arguello on 5/31/25.
//

import FirebaseFirestore

struct Social: Identifiable, Codable, Hashable {
    var numSeeds: Int
    var moodLevel: Int
    var friends: [String]
    var userId: String
    
    @DocumentID var id: String?
}
