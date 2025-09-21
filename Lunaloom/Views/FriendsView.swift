//
//  FriendsView.swift
//  Lunaloom
//
//  Created by Lester Arguello on 5/31/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct FriendsView: View {
    @Environment(AuthController.self) private var authController
    @State private var socials: [Social] = []
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Text("Friends")
                    .font(.largeTitle.bold())
                    .foregroundColor(.yellow)
                    .shadow(radius: 2)
                    .padding(.top)
                
                List {
                    // MARK: Find Friends Section
                    Section(header:
                                Text("Find Friends")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading, -10)
                    ) {
                        ForEach(findFriends) { social in
                            FindFriendRow(
                                social: social,
                                onAddFriend: addFriend
                            )
                            .listRowBackground(Color.clear)
                        }
                        if findFriends.isEmpty {
                            Text("No more users to add.")
                                .foregroundColor(.gray)
                                .italic()
                                .listRowBackground(Color.clear)
                        }
                    }
                    
                    Section(header:
                                Text("My Friends")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading, -10)
                    ) {
                        ForEach(myFriends) { social in
                            MyFriendRow(
                                social: social,
                                onGiveSeed: giveSeed
                            )
                            .listRowBackground(Color.clear)
                        }
                        if myFriends.isEmpty {
                            Text("You haven’t added anyone yet.")
                                .foregroundColor(.gray)
                                .italic()
                                .listRowBackground(Color.clear)
                        }
                    }
                }
                .listStyle(.plain)
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            fetchAllSocials()
        }
    }
    
    func fetchAllSocials() {
        let db = Firestore.firestore()
        db.collectionGroup("social").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }
            guard let documents = snapshot?.documents else {
                self.errorMessage = "No social docs found"
                return
            }
            
            let decoded: [Social] = documents.compactMap { doc in
                do {
                    var s = try doc.data(as: Social.self)
                    
                    if s.userId.isEmpty, let parent = doc.reference.parent.parent?.documentID {
                        s.userId = parent
                    }
                    return s
                } catch {
                    print("Decoding error for doc \(doc.documentID): \(error.localizedDescription)")
                    return nil
                }
            }
            
            DispatchQueue.main.async {
                self.socials = decoded
            }
        }
    }
    
    private var currentSocial: Social {
        let currentUserId = authController.userId
        if let s = socials.first(where: { $0.userId == currentUserId }) {
            return s
        }
        
        return Social(numSeeds: 0, moodLevel: 0, friends: [], userId: currentUserId)
    }
    
    private var currentFriends: [String] {
        currentSocial.friends
    }
    
    private var findFriends: [Social] {
        let meId = authController.userId
        return socials.filter { social in
            social.userId != meId && !currentFriends.contains(social.userId)
        }
    }
    
    private var myFriends: [Social] {
        let meId = authController.userId
        return socials.filter { social in
            currentFriends.contains(social.userId) && social.userId != meId
        }
    }
    
    func addFriend(friendUserId: String) {
        let currentUserId = authController.userId
        let db = Firestore.firestore()
        
        guard
            let mySocial = socials.first(where: {$0.userId == currentUserId}),
            let docId = mySocial.id
        else {
            print("No social found for \(currentUserId)")
            return
        }
        
        print("Found my Social: \(mySocial), docId = \(docId)")
        
        let docRef = db
            .collection("users")
            .document(currentUserId)
            .collection("social")
            .document(docId)
        
        var updatedSocial = mySocial
        updatedSocial.friends.append(friendUserId)
        
        do {
            try docRef.setData(from: updatedSocial, merge: true)
        } catch {
            print("Error updating social data: \(error)")
        }
    }
    
    func giveSeed(friendUserId: String) {
        let currentUserId = authController.userId
        let db = Firestore.firestore()
        
        guard
            let mySocial = socials.first(where: {$0.userId == currentUserId}),
            let myDocId = mySocial.id
        else {
            print("No social found for \(currentUserId)")
            return
        }
        
        guard
            let friendSocial = socials.first(where: {$0.userId == friendUserId}),
            let friendDocId = friendSocial.id
        else {
            print("No social found for \(friendUserId)")
            return
        }
        
        let myDocRef = db
            .collection("users")
            .document(currentUserId)
            .collection("social")
            .document(myDocId)
        
        let friendDocRef = db
            .collection("users")
            .document(friendUserId)
            .collection("social")
            .document(friendDocId)
        
        if mySocial.numSeeds <= 0 {
            self.errorMessage = "You have no seeds to give."
            return
        }
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let mySnap = try transaction.getDocument(myDocRef)
                let friendSnap = try transaction.getDocument(friendDocRef)
                
                let currentData = try mySnap.data(as: Social.self)
                let friendData  = try friendSnap.data(as: Social.self)
                
                var updatedMySocial = currentData
                var updatedFriendSocial = friendData
                updatedMySocial.numSeeds -= 1
                updatedFriendSocial.numSeeds += 1
                
                try transaction.setData(
                    from: updatedMySocial,
                    forDocument: myDocRef,
                    merge: true
                )
                try transaction.setData(
                    from: updatedFriendSocial,
                    forDocument: friendDocRef,
                    merge: true
                )
                
                return nil
            }
            catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }
        }) { (_, error) in
            if let error = error {
                self.errorMessage = "Transaction failed: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    FriendsView()
}
