//
//  Sleep.swift
//  Lunaloom
//
//  Created by Lester Arguello on 5/31/25.
//

import FirebaseFirestore

struct Sleep: Identifiable, Codable, Hashable {
    var remTime: Int
    var coreSleepTime: Int
    var deepSleepTime: Int
    var date: Date
    
    @DocumentID var id: String?
}
