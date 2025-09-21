//
//  ArticleDetailView.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/10/25.
//

import SwiftUI

/*
 View to present an article from a navigation link
 based on ArticleViewModel
 */

struct ArticleDetailView: View {
    var article: Article

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(article.name)
                        .font(.largeTitle.bold())
                        .foregroundColor(.yellow)
                        .shadow(radius: 5)
                        .padding(.top)
                    
                    Image(article.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    Text(article.intro)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.bottom)

                    ForEach(0..<article.headings.count, id: \.self) { index in
                        Text(article.headings[index])
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .shadow(radius: 2)

                        Text(article.paragraphs[index])
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ArticleDetailView(article: Article(
        name: "Snooze Smarter: Science of Perfect Sleep Timing",
        image: "sleep1",
        intro: "Getting a good night’s sleep isn’t just about the number of hours you spend in bed—it’s also about when you sleep...",
        headings: ["The Sleep Cycle Explained", "How to Time Your Sleep", "Tips to Optimize Your Sleep Timing"],
        paragraphs: [
            "Your sleep is divided into cycles, each lasting about 90 minutes...",
            "To snooze smarter, plan your sleep so that you wake up at the end of a cycle...",
            "Stick to a Schedule: Go to bed and wake up at the same time every day..."
        ]
    ))
}
