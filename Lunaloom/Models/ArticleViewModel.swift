//
//  ArticleViewModel.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/10/25.
//

import Foundation
import SwiftUI

/*
 A class to obtain the articles from Articles.plist and put them into an array of Article
 types. loadArticles() uses a property list decoder to retrieve the data.
 */

class ArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []

    init() {
        loadArticles()
    }

    func loadArticles() {
        // Get the URL for the Article.plist in the app bundle
        if let url = Bundle.main.url(forResource: "Articles", withExtension: "plist"),
           let data = try? Data(contentsOf: url) {
            print("Getting Data from Articles.plist")
            let decoder = PropertyListDecoder()
            if let decodedData = try? decoder.decode([String: Article].self, from: data) {
                // Convert the dictionary into an array of articles
                self.articles = Array(decodedData.values)
            }
        }
    }
}
