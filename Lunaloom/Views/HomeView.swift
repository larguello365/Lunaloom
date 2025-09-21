//
//  HomeView.swift
//  Lunaloom
//
//  Created by Lester Arguello on 3/10/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

/*
 Home interface where user can feed Nyxie and start
 a timer for their bedtime.
 */
struct HomeView: View {
    @Environment(AuthController.self) private var authController
    @FirestoreQuery var socials: [Social]
        
    private let minValue = 0.0
    private let maxValue = 100.0
    
    init(userId: String) {
        _socials = FirestoreQuery(collectionPath: "users/\(userId)/social")
        print(_socials)
    }
    
    var body: some View {
        let currentSocial = socials.first ?? Social(numSeeds: 10, moodLevel: 60, friends: [], userId: authController.userId)
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                           startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Nyxie's Mood")
                        .foregroundColor(.yellow)
                        .font(.headline)
                        .shadow(radius: 2)
                        .padding([.top, .leading])
                    Spacer()
                    HStack {
                        Image("seed")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("x \(currentSocial.numSeeds)")
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                
                HStack {
                    Gauge(value: Double(currentSocial.moodLevel), in: minValue...maxValue) { }
                        .tint(.yellow)
                    
                    Button(action: {
                        updateSeedAndMood(social: currentSocial)
                    }) {
                        Text("Feed")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 100)
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
                
                ZStack {
                    Image("branch")
                        .resizable()
                        .frame(width: 400, height: 100)
                    
                    Image("owl")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .offset(y: -80)
                        .shadow(radius: 5)
                }
                .padding(.top, 100)
                Spacer()
            }
        }
        .navigationTitle("Home")
        .onAppear {
            if socials.isEmpty {
                addSocial()
            }
        }
    }
    
    func addSocial() {
        let db = Firestore.firestore()
        
        let social = Social(
            numSeeds: 10,
            moodLevel: 60,
            friends: [],
            userId: authController.userId,
        )
        
        do {
            _ = try db.collection("users")
                .document(authController.userId)
                .collection("social")
                .addDocument(from: social)
        } catch {
            print("Error saving social data: \(error)")
        }
    }
    
    func updateSeedAndMood(social: Social) {
        guard let docId = social.id else { return }
        let db = Firestore.firestore()
        let docRef = db
                    .collection("users")
                    .document(authController.userId)
                    .collection("social")
                    .document(docId)
        
        if social.numSeeds > 0 {
            var updatedSocial = social
            updatedSocial.numSeeds -= 1
            updatedSocial.moodLevel = min(updatedSocial.moodLevel + 3, Int(maxValue))
            
            do {
                try docRef.setData(from: updatedSocial, merge: true)
            } catch {
                print("Error updating social data: \(error)")
            }
        }
    }
}

#Preview {
    let authController = AuthController()
    HomeView(userId: authController.userId)
}
