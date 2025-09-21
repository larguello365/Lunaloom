//
//  TipsView.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/10/25.
//

import SwiftUI

/*
 View where users can read articles that provide
 suggestions on how to improve their sleep quality
 */

struct TipsView: View {
    @StateObject private var viewModel = ArticleViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Image(systemName: "lightbulb.max.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.yellow)
                        .shadow(radius: 5)

                    Text("Read tips on how to improve your sleep quality.")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .shadow(radius: 2)
                        .padding()
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.articles) { article in
                                NavigationLink(destination: ArticleDetailView(article: article)) {
                                    Text(article.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.8))
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle("Tips")
        }
    }
}

#Preview {
    TipsView()
}
