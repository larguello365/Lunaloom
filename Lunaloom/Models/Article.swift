//
//  Article.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/10/25.
//

import Foundation

/*
 An article struct represents the data found in an article dictionary.
 These articles are found within Articles.plist. Each article contains
 a title (name), followed by an image (found in assets), and an intro paragraph,
 followed by section headings and their respective body paragraphs. I structured
 this struct based on this stack overflow page: https://stackoverflow.com/questions/71809129/swiftui-having-a-plist-to-display
 */

struct Article: Identifiable, Decodable {
    var id = UUID()
    var name: String
    var image: String
    var intro: String
    var headings: [String]
    var paragraphs: [String]
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case image = "Image"
        case intro = "Intro"
        case headings = "Headings"
        case paragraphs = "Paragraphs"
    }
}





